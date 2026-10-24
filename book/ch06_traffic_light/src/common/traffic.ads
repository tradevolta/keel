--  SPDX-License-Identifier: Apache-2.0
--  The traffic light as data: which lamps each aspect lights, how long
--  it is held, and what comes next. No hardware here, so the same
--  package drives the Pico 2 W and the NUCLEO-G474RE.
with Keel.Units; use Keel.Units;

package Traffic is

   type Lamp is (Red, Amber, Green);
   type Lamp_Set is array (Lamp) of Boolean;

   --  The UK sequence: red and amber together before green
   type Aspect is (Stop, Ready, Go, Caution);

   Lit : constant array (Aspect) of Lamp_Set :=
     [Stop    => [Red => True, others => False],
      Ready   => [Red | Amber => True, Green => False],
      Go      => [Green => True, others => False],
      Caution => [Amber => True, others => False]];

   --  Hold times are Keel.Units literals: each is a call to
   --  To_Micro_Seconds, made once when this package elaborates.
   Hold : constant array (Aspect) of Micro_Seconds :=
     [Stop    => "4 s",
      Ready   => "1 s",
      Go      => "4 s",
      Caution => "2 s"];

   function Next (A : Aspect) return Aspect is
     (if A = Aspect'Last then Aspect'First else Aspect'Succ (A));
end Traffic;
