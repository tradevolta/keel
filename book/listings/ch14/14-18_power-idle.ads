--  A wait in the chip's modes under a policy
generic
   with function Clock return Keel.Time.Time;
   --  Wait in mode M, until Deadline at the latest; an interrupt
   --  may end the wait sooner. Run returns at once; Power_Down
   --  does not return.
   with procedure Enter
     (M : Mode; Deadline : Keel.Time.Time);
   --  The policy now: a program may change it as it runs
   with function Current return Policy;
package Idle is
   --  Return at or after Deadline, waiting in the deepest mode
   --  the policy allows each time round. Fits
   --  Keel.Time.Clock_Signature.
   procedure Wait_Until (Deadline : Keel.Time.Time)
     with Pre => Deadline <= Max_Clock;
end Idle;
