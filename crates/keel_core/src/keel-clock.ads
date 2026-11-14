--  SPDX-License-Identifier: Apache-2.0
--  Keel.Clock: the clock tree as data. A PLL's limits are a record
--  of numbers from the datasheet. A PLL_Config can only hold a
--  setting inside its limits, which its Type_Invariant states, and
--  Solve searches for a setting that makes a frequency exactly.
package Keel.Clock
  with Pure, SPARK_Mode
is
   --  Whole hertz. Keel.Units.Hertz stops at 1 GHz, and a VCO runs
   --  faster than that.
   type Frequency is range 0 .. 2**31 - 1;

   --  The reference divider and the feedback multiplier
   subtype Divider is Positive range 1 .. 1_023;
   --  The output dividers
   subtype Post_Divider is Positive range 1 .. 15;

   --  One PLL's rules, from its chip's datasheet. The output is
   --  VCO / (Post_Scale * Post_1 * Post_2): Post_Scale is 1 when the
   --  dividers count in ones, 2 when they only take even values.
   type PLL_Limits is record
      --  The phase detector's input: the reference / Ref_Div
      PFD_Min : Frequency;
      PFD_Max : Frequency;
      --  The oscillator: PFD * Feedback
      VCO_Min : Frequency;
      VCO_Max : Frequency;
      --  The fastest output the chip is rated for
      Rated_Max : Frequency;
      Ref_Div_Max : Divider;
      Feedback_Min : Divider;
      Feedback_Max : Divider;
      Post_1_Max : Post_Divider;
      Post_2_Max : Post_Divider;
      Post_Scale : Post_Divider;
   end record;

   --  Wide enough for any product of a frequency and the dividers
   type Product is range 0 .. 2**62;

   --  The datasheet's rules for one setting, as arithmetic on whole
   --  numbers: PFD = Ref / R and VCO = Ref * F / R, without division.
   function Within
     (L : PLL_Limits; Ref : Frequency; R, F : Divider;
      P1, P2 : Post_Divider) return Boolean
   is (R <= L.Ref_Div_Max
       and then F in L.Feedback_Min .. L.Feedback_Max
       and then P1 <= L.Post_1_Max
       and then P2 <= L.Post_2_Max
       and then Product (L.PFD_Min) * Product (R) <= Product (Ref)
       and then Product (Ref) <= Product (L.PFD_Max) * Product (R)
       and then Product (L.VCO_Min) * Product (R)
                  <= Product (Ref) * Product (F)
       and then Product (Ref) * Product (F)
                  <= Product (L.VCO_Max) * Product (R));

   --  What the output divides the VCO by, times R:
   --  R * Post_Scale * P1 * P2, at most 1023 * 15**3
   function Divisor
     (L : PLL_Limits; R : Divider; P1, P2 : Post_Divider)
      return Product
   is (Product (R) * Product (L.Post_Scale) * Product (P1)
       * Product (P2))
     with Post => Divisor'Result in 1 .. 1_023 * 15**3;

   --  Exactly Target at the output: Target * Divisor is Ref * F.
   function Makes
     (L : PLL_Limits; Ref : Frequency; R, F : Divider;
      P1, P2 : Post_Divider; Target : Frequency) return Boolean
   is (Product (Target) * Divisor (L, R, P1, P2)
       = Product (Ref) * Product (F));

   --  A setting of one PLL, always inside its limits. The default
   --  is the null PLL: 0 Hz in, 0 Hz out, every divider 1.
   type PLL_Config is private;

   function Limits (C : PLL_Config) return PLL_Limits;
   function Reference (C : PLL_Config) return Frequency;
   function Ref_Div (C : PLL_Config) return Divider;
   function Feedback (C : PLL_Config) return Divider;
   function Post_1 (C : PLL_Config) return Post_Divider;
   function Post_2 (C : PLL_Config) return Post_Divider;

   function VCO (C : PLL_Config) return Frequency
     with Post => VCO'Result <= Limits (C).VCO_Max;
   function Output (C : PLL_Config) return Frequency;

   --  Find a setting that makes Target from Ref, preferring the
   --  fastest VCO, as the datasheet's script does: it has the least
   --  jitter. Above Rated_Max only when Overclock is True.
   procedure Solve
     (L : PLL_Limits; Ref, Target : Frequency; Overclock : Boolean;
      Config : out PLL_Config; Found : out Boolean)
     with
       Post =>
         (if Found then
            Limits (Config) = L
            and then Reference (Config) = Ref
            and then Makes (L, Ref, Ref_Div (Config),
                            Feedback (Config), Post_1 (Config),
                            Post_2 (Config), Target)
            and then Output (Config) = Target
            and then (Overclock or else Target <= L.Rated_Max));
private
   type PLL_Config is record
      L : PLL_Limits :=
        (PFD_Min | PFD_Max | VCO_Min | VCO_Max | Rated_Max => 0,
         others => 1);
      Ref : Frequency := 0;
      R : Divider := 1;
      F : Divider := 1;
      P1 : Post_Divider := 1;
      P2 : Post_Divider := 1;
   end record
     with Type_Invariant => Within (L, Ref, R, F, P1, P2);

   function Limits (C : PLL_Config) return PLL_Limits is (C.L);
   function Reference (C : PLL_Config) return Frequency is (C.Ref);
   function Ref_Div (C : PLL_Config) return Divider is (C.R);
   function Feedback (C : PLL_Config) return Divider is (C.F);
   function Post_1 (C : PLL_Config) return Post_Divider is (C.P1);
   function Post_2 (C : PLL_Config) return Post_Divider is (C.P2);
end Keel.Clock;
