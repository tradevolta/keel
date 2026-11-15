--  SPDX-License-Identifier: Apache-2.0
--  Sim_PIO: one state machine, cycle by cycle, for the instructions
--  Chapter 13's programs use (JMP always, !X and X--; OUT X; IN PINS
--  and NULL; SET PINDIRS and X; MOV Y, Y; side-set without enable),
--  with autopull and autopush at a threshold of 1 or 24 bits. It runs
--  the words the assembler made, so the timing it reports is the
--  program's own, not a model's. One pin, open drain or side-set.
with Keel.PIO; use Keel.PIO;

package Sim_PIO is
   type Word_Array is array (Positive range <>) of Word;

   type Event_Kind is (Pin_Low, Pin_High, Sample, Stall);

   type Event is record
      Cycle : Natural;
      Kind  : Event_Kind;
      Value : Boolean := False;
   end record;

   type Event_Array is array (Positive range <>) of Event;

   --  A device on the 1-Wire line: it holds the line low over these
   --  cycles (a presence pulse, or a 0 it sends)
   type Hold is record
      From, To : Natural := 0;
   end record;

   type Hold_Array is array (Positive range <>) of Hold;

   --  Run P from Start with Words to pull, until it stalls on an
   --  empty TX FIFO or Max_Cycles pass. Open_Drain: the pin is low
   --  while PINDIRS is 1 or a device holds it; else side-set drives
   --  it. Pull_Bits: the autopull threshold; OUT shifts left (the top
   --  bit first) when it is 24, right when it is 1.
   function Run
     (P          : Program;
      Start      : Address;
      Words      : Word_Array;
      Pull_Bits  : Positive;
      Open_Drain : Boolean;
      Devices    : Hold_Array;
      Max_Cycles : Positive := 5_000) return Event_Array;
end Sim_PIO;
