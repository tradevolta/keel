--  Each GPIOn_CTRL has its own type in the generated code. The
--  layouts are the same and function 5 is SIO on every pin, so
--  GPIO0's types describe any pin, and an array of them puts
--  the loop back. Each pin has STATUS, then CTRL: 8 bytes.
type Pin_Registers is record
   Status  : GPIO0_STATUS_Register;
   Control : GPIO0_CTRL_Register;
end record;

for Pin_Registers use record
   Status  at 0 range 0 .. 31;
   Control at 4 range 0 .. 31;
end record;

type Pin_Array is array (Pin_Id) of Pin_Registers;
IO : Pin_Array
  with Import, Address => IO_BANK0_Periph'Address;

--  The pad registers already share one type
type Pad_Array is array (Pin_Id) of GPIO_Register;
Pads : Pad_Array
  with Import, Address => PADS_BANK0_Periph.GPIO0'Address;

SIO_Function : constant GPIO0_CTRL_Register :=
  (FUNCSEL => sio_0, others => <>);

--  The pins that have an owner
Taken : Pin_Set := [others => False];

--  Each pin's bit, built once at elaboration (120 bytes of RAM):
--  every Set is then a lookup, not a loop over all 32 pins
Bits : constant array (Pin_Id) of Pin_Set :=
  [for Id in Pin_Id => [for P in Pin => P = Pin (Id)]];

function Only (Id : Pin_Id) return Pin_Set is (Bits (Id));
