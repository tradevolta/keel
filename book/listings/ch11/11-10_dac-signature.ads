generic
   type Output (<>) is limited private;
   --  The output's voltage, from now on, held to 0 .. Full_Scale
   with procedure Set (O : in out Output; V : Volts);
   Full_Scale : Volts;
package Output_Signature is
   --  A signature only names things: nothing in it uses them.
   pragma Warnings (Off, Set);
end Output_Signature;
