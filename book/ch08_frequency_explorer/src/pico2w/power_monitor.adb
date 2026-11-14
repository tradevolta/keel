--  SPDX-License-Identifier: Apache-2.0
with Keel.GPIO.RP2350;    use Keel.GPIO.RP2350;
with RP2350_SVD.Atomic;
with RP2350_SVD.I2C0;     use RP2350_SVD.I2C0;
with RP2350_SVD.IO_BANK0; use RP2350_SVD.IO_BANK0;
with RP2350_SVD.RESETS;   use RP2350_SVD.RESETS;

package body Power_Monitor is

   --  The Adafruit breakout's address with A0 and A1 open
   INA219 : constant := 16#40#;
   --  Shunt voltage register: 10 uV per bit, signed
   Shunt_Voltage : constant := 16#01#;

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  100 kHz from Sys, as the Pico SDK's i2c_set_baudrate does it:
   --  a bit is 3/5 low and 2/5 high, and SDA is held 300 ns
   procedure Set_Timing (Sys : Frequency) is
      Period : constant Frequency := (Sys + 50_000) / 100_000;
      Low    : constant Frequency := Period * 3 / 5;
   begin
      I2C0_Periph.IC_FS_SCL_HCNT :=
        (IC_FS_SCL_HCNT => IC_FS_SCL_HCNT_IC_FS_SCL_HCNT_Field
                             (Period - Low),
         others => <>);
      I2C0_Periph.IC_FS_SCL_LCNT :=
        (IC_FS_SCL_LCNT => IC_FS_SCL_LCNT_IC_FS_SCL_LCNT_Field (Low),
         others => <>);
      I2C0_Periph.IC_FS_SPKLEN :=
        (IC_FS_SPKLEN => IC_FS_SPKLEN_IC_FS_SPKLEN_Field
                           (if Low < 16 then 1 else Low / 16),
         others => <>);
      I2C0_Periph.IC_SDA_HOLD :=
        (IC_SDA_TX_HOLD => IC_SDA_HOLD_IC_SDA_TX_HOLD_Field
                             (Sys * 3 / 10_000_000 + 1),
         others => <>);
   end Set_Timing;

   procedure Retime (Sys : Frequency) is
   begin
      I2C0_Periph.IC_ENABLE := (ENABLE => DISABLED, others => <>);
      Set_Timing (Sys);
      I2C0_Periph.IC_ENABLE := (ENABLE => ENABLED, others => <>);
   end Retime;

   procedure Start (Sys : Frequency; Stat : out Status) is
      I2C0_Only : constant RESET_I2C_Field :=
        (As_Array => True, Arr => [0 => True, 1 => False]);
   begin
      Reserve (4, Stat);
      if Stat /= Ok then
         return;
      end if;
      Reserve (5, Stat);
      if Stat /= Ok then
         return;
      end if;
      Reset_Bits.Clear
        (RESETS_Periph.RESET,
         (Reset_Bits.No_Bits with delta I2C => I2C0_Only));
      loop
         exit when RESETS_Periph.RESET_DONE.I2C.Arr (0);
      end loop;

      --  Disabled while it is set up
      I2C0_Periph.IC_ENABLE := (ENABLE => DISABLED, others => <>);
      I2C0_Periph.IC_CON :=
        (MASTER_MODE      => ENABLED,
         SPEED            => FAST,
         IC_RESTART_EN    => ENABLED,
         IC_SLAVE_DISABLE => SLAVE_DISABLED,
         others           => <>);
      Set_Timing (Sys);
      I2C0_Periph.IC_TAR := (IC_TAR => INA219, others => <>);
      I2C0_Periph.IC_ENABLE := (ENABLE => ENABLED, others => <>);

      IO_BANK0_Periph.GPIO4_CTRL := (FUNCSEL => i2c0_sda, others => <>);
      IO_BANK0_Periph.GPIO5_CTRL := (FUNCSEL => i2c0_scl, others => <>);
   end Start;

   procedure Read (Tenths_mA : out Integer; Stat : out Status) is
      type Raw is mod 2**16;
      Bytes : array (1 .. 2) of Raw := [0, 0];
      Value : Integer;
   begin
      Tenths_mA := 0;
      --  Point at the register, then read two bytes, MSB first
      I2C0_Periph.IC_DATA_CMD :=
        (DAT => Shunt_Voltage, CMD => WRITE, others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (CMD => READ, RESTART => ENABLE, others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (CMD => READ, STOP => ENABLE, others => <>);
      for B of Bytes loop
         Stat := Timeout;
         for Try in 1 .. 100_000 loop
            if I2C0_Periph.IC_RAW_INTR_STAT.TX_ABRT = ACTIVE then
               --  No acknowledge: reading IC_CLR_TX_ABRT clears it
               declare
                  Clear : constant IC_CLR_TX_ABRT_Register :=
                    I2C0_Periph.IC_CLR_TX_ABRT
                    with Unreferenced;
               begin
                  return;
               end;
            end if;
            if I2C0_Periph.IC_STATUS.RFNE = NOT_EMPTY then
               B := Raw (I2C0_Periph.IC_DATA_CMD.DAT);
               Stat := Ok;
               exit;
            end if;
         end loop;
         if Stat /= Ok then
            return;
         end if;
      end loop;

      --  Two's complement, 10 uV per bit across 0.1 ohm: 0.1 mA
      Value := Integer (Bytes (1) * 256 + Bytes (2));
      if Value >= 2**15 then
         Value := Value - 2**16;
      end if;
      Tenths_mA := Value;
   end Read;
end Power_Monitor;
