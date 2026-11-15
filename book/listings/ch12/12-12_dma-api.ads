--  Set Ch up for T and start it. Not_Supported: T isn't Valid,
--  or chains to Ch itself.
procedure Start (Ch : Channel; T : Transfer; Stat : out Status)
  with Pre => Is_Claimed (Ch) and then not Is_Busy (Ch);

--  The same, but don't start it: a chain, or Start_Now, does
procedure Prepare (Ch : Channel; T : Transfer; Stat : out Status)
  with Pre => Is_Claimed (Ch) and then not Is_Busy (Ch);
procedure Start_Now (Ch : Channel)
  with Pre => Is_Claimed (Ch);

function Is_Busy (Ch : Channel) return Boolean;
--  A bus error stopped Ch (datasheet 12.6.7)
function Failed (Ch : Channel) return Boolean;

--  How far Ch has got through To (through From, if To is a
--  register): bytes from its start, or from the ring's start
function Position (Ch : Channel) return Natural
  with Pre => Is_Claimed (Ch);

--  Rounds that Ch has finished since its Start, counted by the
--  interrupt handler
function Rounds (Ch : Channel) return Natural;

--  Sleep until Ch's next round ends (Repeat mode)
procedure Wait_Round (Ch : Channel)
  with Pre => Is_Claimed (Ch);

--  Sleep until Ch has finished (Once mode, with Notify). Done
--  covers its two ends.
procedure Wait (Ch : Channel; Done : out Receipt)
  with Pre => Is_Claimed (Ch);

--  The same, but not past Deadline. Timeout: Ch is still going,
--  and Done covers nothing; Stop it to take its buffers back.
procedure Wait
  (Ch : Channel; Deadline : Keel.Time.Time; Done : out Receipt;
   Stat : out Status)
  with Pre => Is_Claimed (Ch);

--  Stop Ch now, wherever it is, and wait until nothing of it is
--  left on the bus (datasheet 12.6.8.3, erratum RP2350-E5)
procedure Stop (Ch : Channel; Done : out Receipt)
  with Pre  => Is_Claimed (Ch),
       Post => not Is_Busy (Ch);

--  Bus priority for the DMA's read and write ports over the
--  cores (datasheet 2.1.1). On the APB and fast-peripheral
--  arbiters the bits are wired to the wrong managers (erratum
--  RP2350-E27): this sets the priority for SRAM, ROM and XIP.
procedure Favour_DMA (On : Boolean);
