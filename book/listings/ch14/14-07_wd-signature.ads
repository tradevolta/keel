--  What a chip's watchdog provides
generic
   --  Count down from T; reset the chip unless fed in time.
   --  Not_Supported: the counter cannot reach T.
   with procedure Start (T : Timeout_Ms; Stat : out Status);
   --  Start the countdown again from the top
   with procedure Feed;
   --  Why the chip last started
   with function Last_Cause return Reset_Cause;
package Signature is
   pragma Warnings (Off, Start);
   pragma Warnings (Off, Feed);
   pragma Warnings (Off, Last_Cause);
end Signature;
