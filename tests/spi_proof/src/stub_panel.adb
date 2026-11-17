--  SPDX-License-Identifier: Apache-2.0
package body Stub_Panel
  with SPARK_Mode => Off
is
   procedure Acquire (D : in out Device; Stat : out Status) is
   begin
      Stat := Ok;
   end Acquire;

   procedure Release (D : in out Device) is null;
   procedure Write (D : in out Device; Data : Byte_Array) is null;
   procedure Exchange (D : in out Device; Data : in out Byte_Array)
   is null;

   procedure Start_Stream
     (D     : in out Device;
      From  : Keel.DMA.Region;
      Count : Positive;
      Stat  : out Status) is
   begin
      Stat := Ok;
   end Start_Stream;

   procedure Finish_Stream (D : in out Device; Done : out DMA.Receipt)
   is
      Nothing : DMA.Receipt;
   begin
      Done := Nothing;
   end Finish_Stream;

   procedure Set (P : in out Pin; To : GPIO.Level) is null;

   function Clock return Time.Time is (0);
   procedure Wait_Until (Deadline : Time.Time) is null;
end Stub_Panel;
