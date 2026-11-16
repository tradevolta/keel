--  Keel.Time.Bare's own wait is the Sleep: WFI between ticks
procedure Enter (M : Mode; Deadline : Keel.Time.Time) is
begin
   if M /= Run then
      Keel.Time.Bare.Wait_Until (Deadline);
   end if;
end Enter;

Set_Deepest : Mode := Sleep;

--  Only Sleep is real here: deeper limits act as Sleep
procedure Set_Policy (P : Policy) is
begin
   Set_Deepest := Mode'Min (P.Deepest, Sleep);
end Set_Policy;

function Current return Policy is
  ((Deepest => Set_Deepest, Wake => [others => 0]));
