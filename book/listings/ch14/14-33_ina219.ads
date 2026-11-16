type Config is record
   Bus_V   : Bus_Range    := Range_32V;
   Gain    : Shunt_Gain   := Div_8_320mV;
   Bus_ADC : ADC_Setting  := One_12_Bit;
   Sh_ADC  : ADC_Setting  := One_12_Bit;
   Mode    : Mode_Setting := Continuous_SB;
end record;

function Encode (C : Config) return Word is
  (Bus_Range'Pos (C.Bus_V) * 2**13
   + Shunt_Gain'Pos (C.Gain) * 2**11
   + C.Bus_ADC * 2**7 + C.Sh_ADC * 2**3 + C.Mode);

--  The defaults are the reset value, 399Fh
pragma Assert (Encode ((others => <>)) = 16#399F#);

--  The shunt voltage register is two's complement, 10 uV per
--  count at every gain (8.6.3.1)
function Shunt_uV (Raw : Word) return Integer is
  ((if Raw >= 2**15 then Raw - 2**16 else Raw) * 10)
  with Post => Shunt_uV'Result in -327_680 .. 327_670;

--  The bus voltage register: 4 mV per count in bits 15 to 3;
--  bit 1, CNVR, says a conversion is ready; bit 0, OVF, that the
--  power or current overflowed (8.6.3.2)
function Bus_mV (Raw : Word) return Natural is ((Raw / 8) * 4);
function Ready (Raw : Word) return Boolean is (Raw / 2 mod 2 = 1);
function Overflow (Raw : Word) return Boolean is (Raw mod 2 = 1);

--  The current through a shunt of Milliohms, from its voltage
subtype Shunt_Milliohms is Positive range 1 .. 10_000;
function Current_uA
  (Shunt : Integer; Milliohms : Shunt_Milliohms) return Integer
is (Shunt * 1_000 / Milliohms)
  with Pre => Shunt in -327_680 .. 327_670;
