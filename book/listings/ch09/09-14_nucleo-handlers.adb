--  EXTI0 and EXTI1: an edge on A or B. Both lines are read each
--  time, so either handler does the whole job.
procedure Encoder_Handler is
begin
   Acknowledge (Pin_A);
   Acknowledge (Pin_B);
   Update (Knob, Contacts);
   Signal (Changed);
end Encoder_Handler;

procedure EXTI0_Handler
  with Export, Convention => C, External_Name => "keel_isr_6";
procedure EXTI0_Handler renames Encoder_Handler;

procedure EXTI1_Handler
  with Export, Convention => C, External_Name => "keel_isr_7";
procedure EXTI1_Handler renames Encoder_Handler;

--  EXTI4: the push switch
procedure EXTI4_Handler
  with Export, Convention => C, External_Name => "keel_isr_10";

procedure EXTI4_Handler is
begin
   Acknowledge (Switch);
   Press := True;
   Signal (Changed);
end EXTI4_Handler;
