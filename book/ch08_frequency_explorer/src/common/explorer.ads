--  SPDX-License-Identifier: Apache-2.0
--  What the frequency explorer does at each step, worked out from
--  data only: no registers in here, so the host can run it too.
with Keel.Clock; use Keel.Clock;

package Explorer
  with Pure
is
   --  From_Reference: clk_sys straight from the reference.
   --  From_PLL: through the PLL at Setting. Refused: neither can
   --  make the target.
   type Plan_Kind is (From_Reference, From_PLL, Refused);

   type Plan (Kind : Plan_Kind := Refused) is record
      Target : Frequency := 0;
      case Kind is
         when From_PLL =>
            Setting : PLL_Config;
         when others =>
            null;
      end case;
   end record;

   function Plan_For
     (L : PLL_Limits; Ref, Target : Frequency; Overclock : Boolean)
      return Plan
     with Post =>
       Plan_For'Result.Target = Target
       and then (case Plan_For'Result.Kind is
                   when From_Reference => Target = Ref,
                   when From_PLL =>
                     Output (Plan_For'Result.Setting) = Target
                     and then Limits (Plan_For'Result.Setting) = L,
                   when Refused => True);

   --  "150 MHz", or "1.5 MHz" below 10 MHz: kHz to tenths of a MHz
   function MHz_Image (kHz : Natural) return String;

   --  "12 MHz / 1 * 125 / 5 / 2 (VCO 1500 MHz)"
   function Setting_Image (C : PLL_Config) return String;
end Explorer;
