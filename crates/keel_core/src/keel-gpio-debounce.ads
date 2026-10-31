--  SPDX-License-Identifier: Apache-2.0
--  A counting debouncer. Sample the raw pin at a fixed rate: the
--  stable level follows only after Samples samples in a row disagree
--  with it. At one sample per millisecond and Samples = 5, a contact
--  must stay put for 5 ms before the change counts.
package Keel.GPIO.Debounce
  with Pure, SPARK_Mode
is
   subtype Sample_Count is Positive range 1 .. 255;

   --  Starts at Low: Reset it to the input's idle level first.
   type Debouncer (Samples : Sample_Count) is private;

   --  The debounced level
   function Stable (D : Debouncer) return Level;

   --  How many samples in a row have disagreed with Stable
   function Pending (D : Debouncer) return Natural
     with Post => Pending'Result < D.Samples;

   procedure Reset (D : out Debouncer; To : Level)
     with Post => Stable (D) = To and then Pending (D) = 0;

   --  Feed one raw sample. Changed is True for exactly the sample
   --  that completes a run of D.Samples disagreeing samples.
   procedure Sample
     (D : in out Debouncer; Raw : Level; Changed : out Boolean)
     with
       Post =>
         Changed = (Raw /= Stable (D'Old)
                    and then Pending (D'Old) + 1 = D.Samples)
         and then Stable (D) =
           (if Changed then Raw else Stable (D'Old))
         and then Pending (D) =
           (if Raw = Stable (D'Old) or else Changed then 0
            else Pending (D'Old) + 1);
private
   type Debouncer (Samples : Sample_Count) is record
      Now   : Level   := Low;
      Count : Natural := 0;
   end record
     with Type_Invariant => Count < Samples;

   function Stable (D : Debouncer) return Level is (D.Now);
   function Pending (D : Debouncer) return Natural is (D.Count);
end Keel.GPIO.Debounce;
