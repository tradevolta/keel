--  SPDX-License-Identifier: Apache-2.0
with RP2350_SVD.Atomic;
with RP2350_SVD.IO_BANK0;   use RP2350_SVD.IO_BANK0;
with RP2350_SVD.PADS_BANK0; use RP2350_SVD.PADS_BANK0;
with RP2350_SVD.RESETS;     use RP2350_SVD.RESETS;
with RP2350_SVD.SIO_Pins;   use RP2350_SVD.SIO_Pins;

package body Knob is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  Edge latches of GP16 and GP17 in INTR2 (write 1 to clear)
   Edges_16_17 : constant INTR2_Register :=
     (GPIO16_EDGE_LOW | GPIO16_EDGE_HIGH |
      GPIO17_EDGE_LOW | GPIO17_EDGE_HIGH => True, others => <>);

   function Contacts return Phase is
     (Phase_Of (A => Input (16), B => Input (17)));

   procedure Start is
      Up : constant GPIO_Register :=
        (PUE => True, PDE => False, IE => True, ISO => False,
         others => <>);
   begin
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta
            IO_BANK0 => True, PADS_BANK0 => True));
      loop
         exit when RESETS_Periph.RESET_DONE.IO_BANK0
           and then RESETS_Periph.RESET_DONE.PADS_BANK0;
      end loop;
      Disable_Output ([16 | 17 => True, others => False]);
      IO_BANK0_Periph.GPIO16_CTRL := (FUNCSEL => sio_16, others => <>);
      IO_BANK0_Periph.GPIO17_CTRL := (FUNCSEL => sio_17, others => <>);
      PADS_BANK0_Periph.GPIO16 := Up;
      PADS_BANK0_Periph.GPIO17 := Up;
      IO_BANK0_Periph.INTR2 := Edges_16_17;
      IO_BANK0_Periph.PROC0_INTE2 :=
        (GPIO16_EDGE_LOW | GPIO16_EDGE_HIGH |
         GPIO17_EDGE_LOW | GPIO17_EDGE_HIGH => True, others => <>);
   end Start;

   protected body Encoder is
      entry Changed (Position : out Volume) when Moved is
      begin
         Position := D.Position;
         Moved := False;
      end Changed;

      procedure Handler is
      begin
         IO_BANK0_Periph.INTR2 := Edges_16_17;
         Update (D, Contacts);
         Moved := True;
      end Handler;
   end Encoder;
end Knob;
