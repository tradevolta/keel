--  SPDX-License-Identifier: Apache-2.0
--  The knob's encoder on GP16 (A) and GP17 (B), decoded by an Ada
--  protected handler. The runtime owns the vector table: it calls
--  Handler at the protected object's priority.
with Ada.Interrupts.Names;
with System;
with Keel.Quadrature; use Keel.Quadrature;

package Knob is
   subtype Volume is Count range 0 .. 32;

   --  Connect the pins and ask for interrupts on both edges
   procedure Start;

   protected Encoder
     with Interrupt_Priority => System.Interrupt_Priority'First
   is
      --  Blocks until the knob has moved, then gives its position
      entry Changed (Position : out Volume);
   private
      procedure Handler
        with Attach_Handler =>
               Ada.Interrupts.Names.IO_IRQ_BANK0_Interrupt_CPU_1;

      D     : Decoder (Low => Volume'First, High => Volume'Last);
      Moved : Boolean := False;
   end Encoder;
end Knob;
