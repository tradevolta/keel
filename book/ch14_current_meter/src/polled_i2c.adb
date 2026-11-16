--  SPDX-License-Identifier: Apache-2.0
--  Chapter 8's polled I2C0 (power_monitor.adb), opened up to any
--  address and register, and to writes
with Keel.GPIO.RP2350;    use Keel.GPIO.RP2350;
with RP2350_SVD.Atomic;
with RP2350_SVD.I2C0;     use RP2350_SVD.I2C0;
with RP2350_SVD.IO_BANK0; use RP2350_SVD.IO_BANK0;
with RP2350_SVD.RESETS;   use RP2350_SVD.RESETS;

package body Polled_I2C is

   package Reset_Bits is new RP2350_SVD.Atomic (RESET_Register);

   --  The polls give up after this many tries: at 12 MHz, about
   --  50 ms, which is many times a 3-byte transfer at 100 kHz
   Tries : constant := 100_000;

   Target : Natural := 16#55#;   --  IC_TAR's reset value

   --  100 kHz from Sys, as Chapter 8 did it: a bit is 3/5 low and
   --  2/5 high, and SDA is held 300 ns
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

   procedure Start (B : in out Bus; Sys : Frequency; Stat : out Status)
   is
      pragma Unreferenced (B);
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

      I2C0_Periph.IC_ENABLE := (ENABLE => DISABLED, others => <>);
      I2C0_Periph.IC_CON :=
        (MASTER_MODE      => ENABLED,
         SPEED            => FAST,
         IC_RESTART_EN    => ENABLED,
         IC_SLAVE_DISABLE => SLAVE_DISABLED,
         others           => <>);
      Set_Timing (Sys);
      I2C0_Periph.IC_ENABLE := (ENABLE => ENABLED, others => <>);

      IO_BANK0_Periph.GPIO4_CTRL := (FUNCSEL => i2c0_sda, others => <>);
      IO_BANK0_Periph.GPIO5_CTRL := (FUNCSEL => i2c0_scl, others => <>);
   end Start;

   --  IC_TAR can change only while the controller is off
   procedure Aim (Address : Natural) is
   begin
      if Address /= Target then
         I2C0_Periph.IC_ENABLE := (ENABLE => DISABLED, others => <>);
         I2C0_Periph.IC_TAR :=
           (IC_TAR => IC_TAR_IC_TAR_Field (Address), others => <>);
         I2C0_Periph.IC_ENABLE := (ENABLE => ENABLED, others => <>);
         Target := Address;
      end if;
   end Aim;

   --  Reading a clear register clears its flag
   procedure Clear_Abort is
      Clear : constant IC_CLR_TX_ABRT_Register :=
        I2C0_Periph.IC_CLR_TX_ABRT
        with Unreferenced;
   begin
      null;
   end Clear_Abort;

   procedure Clear_Stop is
      Clear : constant IC_CLR_STOP_DET_Register :=
        I2C0_Periph.IC_CLR_STOP_DET
        with Unreferenced;
   begin
      null;
   end Clear_Stop;

   --  Wait for the STOP that ends a transfer: Timeout if the target
   --  did not acknowledge, or no STOP came
   procedure Wait_Stop (Stat : out Status) is
   begin
      Stat := Timeout;
      for Try in 1 .. Tries loop
         if I2C0_Periph.IC_RAW_INTR_STAT.TX_ABRT = ACTIVE then
            Clear_Abort;
            Clear_Stop;
            return;
         end if;
         if I2C0_Periph.IC_RAW_INTR_STAT.STOP_DET = ACTIVE then
            Clear_Stop;
            Stat := Ok;
            return;
         end if;
      end loop;
   end Wait_Stop;

   procedure Read_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : out Natural; Stat : out Status)
   is
      pragma Unreferenced (B);
      type Raw is mod 2**8;
      Bytes : array (1 .. 2) of Raw := [0, 0];
   begin
      Value := 0;
      Aim (Address);
      Clear_Stop;
      --  Point at the register, then read two bytes, MSB first
      I2C0_Periph.IC_DATA_CMD :=
        (DAT => IC_DATA_CMD_DAT_Field (Register), CMD => WRITE,
         others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (CMD => READ, RESTART => ENABLE, others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (CMD => READ, STOP => ENABLE, others => <>);
      for X of Bytes loop
         Stat := Timeout;
         for Try in 1 .. Tries loop
            if I2C0_Periph.IC_RAW_INTR_STAT.TX_ABRT = ACTIVE then
               Clear_Abort;
               Clear_Stop;
               return;
            end if;
            if I2C0_Periph.IC_STATUS.RFNE = NOT_EMPTY then
               X := Raw (I2C0_Periph.IC_DATA_CMD.DAT);
               Stat := Ok;
               exit;
            end if;
         end loop;
         if Stat /= Ok then
            return;
         end if;
      end loop;
      Wait_Stop (Stat);
      Value := Natural (Bytes (1)) * 256 + Natural (Bytes (2));
   end Read_Register;

   procedure Write_Register
     (B : in out Bus; Address : Natural; Register : Natural;
      Value : Natural; Stat : out Status)
   is
      pragma Unreferenced (B);
   begin
      Aim (Address);
      Clear_Stop;
      I2C0_Periph.IC_DATA_CMD :=
        (DAT => IC_DATA_CMD_DAT_Field (Register), CMD => WRITE,
         others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (DAT => IC_DATA_CMD_DAT_Field (Value / 256 mod 256),
         CMD => WRITE, others => <>);
      I2C0_Periph.IC_DATA_CMD :=
        (DAT => IC_DATA_CMD_DAT_Field (Value mod 256), CMD => WRITE,
         STOP => ENABLE, others => <>);
      Wait_Stop (Stat);
   end Write_Register;
end Polled_I2C;
