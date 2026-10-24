type Pin is range 0 .. 15;

type Mode is (Input, Output, Alternate, Analog)
  with Size => 2;
for Mode use (Input => 2#00#, Output => 2#01#,
              Alternate => 2#10#, Analog => 2#11#);

--  Change the mode of one pin of Port, in one read and one write
--  of MODER. Analog is the reset mode of most pins.
procedure Set_Mode
  (Port : in out GPIO_Peripheral; P : Pin; To : Mode)
  with Inline;

function Mode_Of (Port : GPIO_Peripheral; P : Pin) return Mode
  with Inline;
