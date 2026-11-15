--  SPDX-License-Identifier: Apache-2.0
--  WS2812 LEDs from a PIO state machine running
--  Keel.PIO.WS2812_Program at 800 kbit/s: the transport under
--  Keel.Drivers.WS2812. The joined TX FIFO holds 8 pixels, so Put
--  only waits when 8 are queued.
with Keel.Time;

package Keel.PIO.RP2350.WS2812 is
   type Strip (B : Block; M : Machine; Pin : Pin_Id) is limited private;

   function Is_Open (S : Strip) return Boolean;

   --  Load the program into block B, claim M and the pin, and start
   --  M at 8 MHz, 10 cycles a bit, from a system clock of Clock_Hz.
   --  Not_Supported: no room in B. In_Use: M or the pin has an owner.
   procedure Open
     (S : in out Strip; Clock_Hz : Positive; Stat : out Status)
     with Pre  => Is_Enabled (S.B) and then not Is_Open (S)
                  and then Clock_Hz >= 8_000_000,
          Post => Is_Open (S) = (Stat = Ok);

   --  Queue 24 bits, green, red, blue, most significant first
   procedure Put (S : in out Strip; GRB : Word; Stat : out Status)
     with Pre => Is_Open (S) and then GRB < 2**24;

   --  Wait for the queue to empty and the last pixel to go, then hold
   --  the line low for Reset_Time microseconds, so the LEDs show what
   --  they took. Timeout: the queue did not empty within 1 ms.
   procedure Latch
     (S          : in out Strip;
      Reset_Time : Keel.Time.Time_Span;
      Stat       : out Status)
     with Pre => Is_Open (S) and then Reset_Time in 0 .. 10_000;

private
   type Strip (B : Block; M : Machine; Pin : Pin_Id) is limited record
      Open : Boolean := False;
   end record;

   function Is_Open (S : Strip) return Boolean is (S.Open);
end Keel.PIO.RP2350.WS2812;
