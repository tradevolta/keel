--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD;        use RP2350_SVD;
with RP2350_SVD.ADC;    use RP2350_SVD.ADC;
with RP2350_SVD.Atomic;
with RP2350_SVD.RESETS; use RP2350_SVD.RESETS;

package body Keel.ADC.RP2350 is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  Polls before Timeout: far longer than a conversion takes
   Patience : constant := 100_000;

   Claimed : Channel_Set := [others => False];
   Powered : Boolean := False;

   function Is_Enabled return Boolean is (Powered);
   function Is_Claimed (Ch : Channel) return Boolean is (Claimed (Ch));

   --  CS with the converter on and the sensor's bias as claimed
   function Base return CS_Register is
     (EN => True, TS_EN => Claimed (Temperature_Sensor),
      others => <>);

   function Wait_Ready return Boolean is
   begin
      for Try in 1 .. Patience loop
         if ADC_Periph.CS.READY then
            return True;
         end if;
      end loop;
      return False;
   end Wait_Ready;

   procedure Enable (Stat : out Status) is
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta ADC => True));
      loop
         exit when RESETS_Periph.RESET_DONE.ADC;
      end loop;
      ADC_Periph.CS := Base;
      Powered := Wait_Ready;
      Stat := (if Powered then Ok else Timeout);
   end Enable;

   procedure Claim (Ch : Channel; Stat : out Status) is
   begin
      if Ch = Temperature_Sensor then
         Stat := Ok;
      else
         Keel.GPIO.RP2350.Reserve_Analog (Pin_Of (Ch), Stat);
      end if;
      if Stat = Ok then
         Claimed (Ch) := True;
         --  The sensor's bias (datasheet 12.4.6), if it is claimed
         ADC_Periph.CS := Base;
      end if;
   end Claim;

   procedure Read (Ch : Channel; Value : out Code; Stat : out Status)
   is
      CS : CS_Register := Base;
   begin
      Value := 0;
      Stat := Timeout;
      CS.AINSEL := CS_AINSEL_Field (Ch);
      for Try in 1 .. 3 loop
         exit when not Wait_Ready;
         CS.START_ONCE := True;
         ADC_Periph.CS := CS;
         exit when not Wait_Ready;
         --  ERR: the most recent conversion didn't converge
         if not ADC_Periph.CS.ERR then
            Value := Code (ADC_Periph.RESULT.RESULT);
            Stat := Ok;
            exit;
         end if;
      end loop;
   end Read;

   --  Empty the FIFO, and clear its sticky flags (write 1)
   procedure Drain is
      F : FIFO_Register;
   begin
      for Try in 1 .. 16 loop
         exit when ADC_Periph.FCS.EMPTY;
         F := ADC_Periph.FIFO;
      end loop;
      pragma Unreferenced (F);
   end Drain;

   Streaming : Boolean := False;

   function Is_Streaming return Boolean is (Streaming);

   --  Set up free-running conversions of Inputs at Rate, round robin
   --  from the lowest, into the FIFO, and start them. For_DMA turns
   --  the FIFO's DMA request on. Count: how many inputs. Stat as for
   --  Capture.
   procedure Start_Many
     (Inputs : Channel_Set; Rate : Hertz; For_DMA : Boolean;
      Count : out Natural; Stat : out Status)
   is
      --  48 MHz in 1/256 cycles over Rate: DIV is that period less
      --  one cycle, as INT and FRAC (datasheet 12.4.3.2)
      Period : Long_Long_Integer;
      Mask   : CS_RROBIN_Field := 0;
      First  : Channel := 0;
      CS     : CS_Register := Base;
   begin
      Count := 0;
      Stat := Not_Supported;
      if Rate < Slowest or else Rate > Fastest then
         return;
      end if;
      for Ch in reverse Channel loop
         if Inputs (Ch) then
            Mask := Mask or 2**Natural (Ch);
            First := Ch;
            Count := Count + 1;
         end if;
      end loop;
      Period := 48_000_000 * 256 / Long_Long_Integer (Rate) - 256;

      Stat := Timeout;
      if not Wait_Ready then
         return;
      end if;
      Drain;
      ADC_Periph.FCS :=
        (EN => True, ERR => True, DREQ_EN => For_DMA, THRESH => 1,
         UNDER => True, OVER => True, others => <>);
      ADC_Periph.DIV :=
        (INT => DIV_INT_Field (Period / 256),
         FRAC => DIV_FRAC_Field (Period mod 256), others => <>);
      CS.AINSEL := CS_AINSEL_Field (First);
      CS.RROBIN := Mask;
      CS.START_MANY := True;
      ADC_Periph.CS := CS;
      Stat := Ok;
   end Start_Many;

   --  Stop, let the last conversion finish, and drain the rest.
   --  Lost: the FIFO overflowed, or the ADC never got ready.
   procedure Stop_Many (Lost : out Boolean) is
      Got : Boolean;
   begin
      ADC_Periph.CS := Base;
      Got := Wait_Ready;
      Lost := ADC_Periph.FCS.OVER or else not Got;
      Drain;
      ADC_Periph.FCS := (OVER => True, UNDER => True, others => <>);
      ADC_Periph.DIV := (others => <>);
   end Stop_Many;

   procedure Capture
     (Inputs : Channel_Set; Rate : Hertz; Samples : out Sample_Array;
      Errors : out Natural; Stat : out Status)
   is
      Count  : Natural;
      F      : FIFO_Register;
      Got    : Boolean;
      Lost   : Boolean;
   begin
      Samples := [others => 0];
      Errors := 0;
      if Samples'Length = 0 then
         Stat := (if Rate in Slowest .. Fastest then Ok
                  else Not_Supported);
         return;
      end if;
      Start_Many (Inputs, Rate, False, Count, Stat);
      if Stat /= Ok then
         return;
      end if;

      Stat := Timeout;
      for I in Samples'Range loop
         Got := False;
         for Try in 1 .. Patience loop
            if not ADC_Periph.FCS.EMPTY then
               Got := True;
               exit;
            end if;
         end loop;
         exit when not Got;
         F := ADC_Periph.FIFO;
         if not F.ERR then
            Samples (I) := Code (F.VAL);
         else
            --  Discard it (datasheet 12.4.3.4): keep the last good
            --  sample from the same input, if there is one
            Errors := Errors + 1;
            if I - Samples'First >= Count then
               Samples (I) := Samples (I - Count);
            end if;
         end if;
         if I = Samples'Last then
            Stat := Ok;
         end if;
      end loop;

      Stop_Many (Lost);
      if Lost then
         Stat := Timeout;
      end if;
   end Capture;

   procedure Start_Stream
     (Inputs : Channel_Set; Rate : Hertz; Stat : out Status)
   is
      Count : Natural;
   begin
      Start_Many (Inputs, Rate, True, Count, Stat);
      Streaming := Stat = Ok;
   end Start_Stream;

   procedure Stop_Stream (Lost : out Boolean) is
   begin
      Stop_Many (Lost);
      Streaming := False;
   end Stop_Stream;

   function FIFO return Keel.DMA.Region is
     (Keel.DMA.Register (ADC_Periph.FIFO'Address));
end Keel.ADC.RP2350;
