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
