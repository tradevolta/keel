--  SPDX-License-Identifier: Apache-2.0
--  A package spec: what clients may use. The private part is for
--  the compiler (sizes), not for clients.
with Units; use Units;

package Moving_Average is

   Window_Length : constant := 4;

   type Window is private;

   procedure Reset (W : out Window)
     with Post => Count (W) = 0;

   procedure Add (W : in out Window; Sample : Milli_Volts)
     with Post =>
       Count (W) = Natural'Min (Count (W)'Old + 1, Window_Length);

   function Count (W : Window) return Natural;

   function Mean (W : Window) return Milli_Volts
     with Pre => Count (W) > 0;

private
   type Index is mod Window_Length;
   type Sample_Array is array (Index) of Milli_Volts;

   type Window is record
      Samples : Sample_Array := [others => 0];
      Next    : Index := 0;
      Filled  : Natural range 0 .. Window_Length := 0;
   end record
     with Type_Invariant =>      --  until full, Next counts the samples
       Window.Filled = Window_Length
         or else Natural (Window.Next) = Window.Filled;
end Moving_Average;
