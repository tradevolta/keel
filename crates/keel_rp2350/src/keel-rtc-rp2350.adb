--  SPDX-License-Identifier: Apache-2.0
with Interfaces; use Interfaces;
with RP2350_SVD; use RP2350_SVD;
with RP2350_SVD.POWMAN_Words;

package body Keel.RTC.RP2350 is

   package Words renames RP2350_SVD.POWMAN_Words;
   use type Words.Offset;

   --  TIMER's bits (Table 544)
   RUN            : constant UInt32 := 2**1;
   ALARM_ENAB     : constant UInt32 := 2**4;
   PWRUP_ON_ALARM : constant UInt32 := 2**5;
   ALARM          : constant UInt32 := 2**6;
   Use_LPOSC_Bit  : constant UInt32 := 2**8;
   Use_XOSC_Bit   : constant UInt32 := 2**9;
   USING_XOSC     : constant UInt32 := 2**16;
   USING_LPOSC    : constant UInt32 := 2**17;

   function Running return Boolean is
     ((Words.Read (Words.TIMER) and RUN) /= 0);

   --  A 64-bit time as four 16-bit writes, most significant first,
   --  into four registers 4 bytes apart (SET_TIME_*, ALARM_TIME_*)
   procedure Write_64 (First : Words.Offset; T : Epoch_Ms) is
      V : constant Unsigned_64 := Unsigned_64 (T);
   begin
      for I in 0 .. 3 loop
         Words.Write
           (First + Words.Offset (4 * I),
            UInt32 (Shift_Right (V, 48 - 16 * I) and 16#FFFF#));
      end loop;
   end Write_64;

   procedure Start (T : Epoch_Ms) is
   begin
      Words.Clear_Bits (Words.TIMER, RUN);
      Write_64 (Words.SET_TIME_63TO48, T);
      Words.Set_Bits (Words.TIMER, Use_LPOSC_Bit);
      Words.Set_Bits (Words.TIMER, RUN);
   end Start;

   procedure Set (T : Epoch_Ms) is
      Crystal : constant Boolean := Running and then On_Crystal;
   begin
      Start (T);
      if Crystal then
         Use_Crystal;
      end if;
   end Set;

   --  Ask for a source and wait, a bounded while, until it is in use
   procedure Switch (Choose, Using : UInt32) is
   begin
      Words.Set_Bits (Words.TIMER, Choose);
      for Try in 1 .. 100_000 loop
         exit when (Words.Read (Words.TIMER) and Using) /= 0;
      end loop;
   end Switch;

   procedure Use_Crystal is
   begin
      Switch (Use_XOSC_Bit, USING_XOSC);
   end Use_Crystal;

   procedure Use_LPOSC is
   begin
      Switch (Use_LPOSC_Bit, USING_LPOSC);
   end Use_LPOSC;

   function On_Crystal return Boolean is
     ((Words.Read (Words.TIMER) and USING_XOSC) /= 0);

   function Now return Epoch_Ms is
      Hi : UInt32 := Words.Read (Words.READ_TIME_UPPER);
      Lo, Hi_Again : UInt32;
      V : Unsigned_64;
   begin
      loop
         Lo := Words.Read (Words.READ_TIME_LOWER);
         Hi_Again := Words.Read (Words.READ_TIME_UPPER);
         exit when Hi_Again = Hi;
         Hi := Hi_Again;
      end loop;
      V := Shift_Left (Unsigned_64 (Hi), 32) or Unsigned_64 (Lo);
      return Epoch_Ms
        (Unsigned_64'Min (V, Unsigned_64 (Epoch_Ms'Last)));
   end Now;

   procedure Set_Alarm (T : Epoch_Ms; Power_Up : Boolean := False) is
   begin
      --  The alarm must be off while its time is written (12.10.4)
      Words.Clear_Bits (Words.TIMER, ALARM_ENAB or PWRUP_ON_ALARM);
      Write_64 (Words.ALARM_TIME_63TO48, T);
      --  ALARM is write-1-to-clear; the Pico SDK's
      --  powman_clear_alarm writes it through the clear alias
      Words.Clear_Bits (Words.TIMER, ALARM);
      Words.Set_Bits
        (Words.TIMER,
         ALARM_ENAB or (if Power_Up then PWRUP_ON_ALARM else 0));
   end Set_Alarm;

   procedure Clear_Alarm is
   begin
      Words.Clear_Bits (Words.TIMER, ALARM_ENAB or PWRUP_ON_ALARM);
      Words.Clear_Bits (Words.TIMER, ALARM);
   end Clear_Alarm;

   function Alarm_Fired return Boolean is
     ((Words.Read (Words.TIMER) and ALARM) /= 0);
end Keel.RTC.RP2350;
