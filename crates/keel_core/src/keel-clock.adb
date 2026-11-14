--  SPDX-License-Identifier: Apache-2.0
package body Keel.Clock
  with SPARK_Mode
is
   --  A / D = T when A is T * D: the step from Makes to Output
   procedure Lemma_Exact (A, D, T : Product)
     with
       Ghost,
       Pre => D > 0 and then T <= Product'Last / D and then A = T * D,
       Post => A / D = T;

   procedure Lemma_Exact (A, D, T : Product) is null;

   function VCO (C : PLL_Config) return Frequency is
     (Frequency (Product (C.Ref) * Product (C.F) / Product (C.R)));

   function Output (C : PLL_Config) return Frequency is
     (Frequency (Product (C.Ref) * Product (C.F)
        / Divisor (C.L, C.R, C.P1, C.P2)));

   --  The feedback divider that makes Target with R, P1 and P2, if
   --  there is one inside L
   procedure Candidate
     (L : PLL_Limits; Ref, Target : Frequency; R : Divider;
      P1, P2 : Post_Divider; F : out Divider; Ok : out Boolean)
     with
       Pre => Ref > 0,
       Post =>
         (if Ok then
            Within (L, Ref, R, F, P1, P2)
            and then Makes (L, Ref, R, F, P1, P2, Target))
   is
      --  Target * Divisor: Ref * F must equal it
      Need : constant Product :=
        Product (Target) * Divisor (L, R, P1, P2);
      Quotient : constant Product := Need / Product (Ref);
   begin
      F := 1;
      Ok := False;
      if Need mod Product (Ref) = 0
        and then Quotient in 1 .. Product (Divider'Last)
      then
         pragma Assert (Product (Ref) * Quotient = Need);
         F := Divider (Quotient);
         Ok := Within (L, Ref, R, F, P1, P2);
      end if;
   end Candidate;

   --  What Solve keeps true: Config is inside its limits and, once
   --  Found, makes Target from Ref with L.
   function So_Far
     (C : PLL_Config; Found : Boolean; L : PLL_Limits;
      Ref, Target : Frequency) return Boolean
   is (Within (C.L, C.Ref, C.R, C.F, C.P1, C.P2)
       and then
         (if Found then
            C.L = L and then C.Ref = Ref
            and then Makes (L, Ref, C.R, C.F, C.P1, C.P2, Target)))
     with Ghost;

   procedure Solve
     (L : PLL_Limits; Ref, Target : Frequency; Overclock : Boolean;
      Config : out PLL_Config; Found : out Boolean)
   is
      Null_PLL : constant PLL_Config := (others => <>);
      --  The VCO of the best setting so far
      Best : Frequency := 0;
      F : Divider;
      Ok : Boolean;
   begin
      Config := Null_PLL;
      Found := False;
      if Ref = 0 or else Target = 0
        or else (Target > L.Rated_Max and then not Overclock)
      then
         return;
      end if;
      for R in 1 .. L.Ref_Div_Max loop
         for P1 in reverse 1 .. L.Post_1_Max loop
            for P2 in reverse 1 .. Post_Divider'Min (P1, L.Post_2_Max)
            loop
               Candidate (L, Ref, Target, R, P1, P2, F, Ok);
               if Ok
                 and then Product (Ref) * Product (F) / Product (R)
                            > Product (Best)
               then
                  Config :=
                    (L => L, Ref => Ref, R => R, F => F,
                     P1 => P1, P2 => P2);
                  Best := VCO (Config);
                  Found := True;
               end if;
               pragma Loop_Invariant
                 (So_Far (Config, Found, L, Ref, Target));
            end loop;
            pragma Loop_Invariant
              (So_Far (Config, Found, L, Ref, Target));
         end loop;
         pragma Loop_Invariant
           (So_Far (Config, Found, L, Ref, Target));
      end loop;
      if Found then
         Lemma_Exact
           (Product (Ref) * Product (Config.F),
            Divisor (L, Config.R, Config.P1, Config.P2),
            Product (Target));
      end if;
   end Solve;
end Keel.Clock;
