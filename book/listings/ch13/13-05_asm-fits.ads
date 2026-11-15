generic
   Side_Bits     : Side_Count := 0;
   Side_Optional : Boolean := False;
package Keel.PIO.Assembler
  with Pure, SPARK_Mode
is
   pragma Compile_Time_Error
     (Side_Bits + Boolean'Pos (Side_Optional) > 5,
      "side-set and its enable bit take at most 5 bits");

   Field_Bits : constant Natural :=
     Side_Bits + Boolean'Pos (Side_Optional);
   Max_Idle   : constant Natural := 2**(5 - Field_Bits) - 1;
   Max_Side   : constant Natural := 2**Side_Bits - 1;

   --  A side-set value, or No_Side
   subtype Side_Value is Integer range -1 .. 31;
   No_Side : constant Side_Value := -1;

   --  Side and Idle fit the field. Without side-set there is no
   --  value to give; with it, each instruction must give one,
   --  unless it is optional.
   function Fits (Side : Side_Value; Idle : Natural) return Boolean is
     (Idle <= Max_Idle
      and then (if Side_Bits = 0 then Side = No_Side
                else Side <= Max_Side
                     and then (Side /= No_Side or else Side_Optional)));
