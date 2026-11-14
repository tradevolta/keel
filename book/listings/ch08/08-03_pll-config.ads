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
