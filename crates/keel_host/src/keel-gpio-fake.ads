--  SPDX-License-Identifier: Apache-2.0
--  Keel.GPIO on the host: the API of Keel.GPIO.RP2350 over an array
--  of simulated pins. A test plays the world outside the chip:
--  Press drives an input, Lamp reads what an output drives.
package Keel.GPIO.Fake
  with Preelaborate
is
   type Pin_Id is range 0 .. 31;

   type Output_Pin (Id : Pin_Id) is limited private;
   type Input_Pin (Id : Pin_Id) is limited private;

   function Is_Claimed (P : Output_Pin) return Boolean;
   function Is_Claimed (P : Input_Pin) return Boolean;

   function Driven (P : Output_Pin) return Level
     with Pre => Is_Claimed (P);

   procedure Claim
     (P : in out Output_Pin; Config : Output_Config; Stat : out Status)
     with Pre  => not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok)
                  and then (if Stat = Ok
                            then Driven (P) = Config.Initial);

   procedure Claim
     (P : in out Input_Pin; Config : Input_Config; Stat : out Status)
     with Pre  => not Is_Claimed (P),
          Post => Is_Claimed (P) = (Stat = Ok);

   procedure Release (P : in out Output_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);
   procedure Release (P : in out Input_Pin)
     with Pre => Is_Claimed (P), Post => not Is_Claimed (P);

   procedure Set (P : in out Output_Pin; To : Level)
     with Pre => Is_Claimed (P), Post => Driven (P) = To;

   function Get (P : Input_Pin) return Level
     with Pre => Is_Claimed (P);

   --  Test hooks: the world outside the chip

   --  Drive pin Id from outside, as a button or a wire would
   procedure Press (Id : Pin_Id; To : Level);

   --  Stop driving pin Id: it reads its pull again (Floating and
   --  Pull_Down read Low, Pull_Up reads High)
   procedure Let_Go (Id : Pin_Id);

   --  What pin Id drives now, and how often it has changed
   function Lamp (Id : Pin_Id) return Level;
   function Edges (Id : Pin_Id) return Natural;

   --  Refuse Pull_Down with Not_Supported, like an RP2350 A2
   procedure Refuse_Pull_Down (Refuse : Boolean);

   --  Every pin back to unclaimed, undriven and Low
   procedure Reset_All;

private
   type Output_Pin (Id : Pin_Id) is limited record
      Claimed : Boolean := False;
   end record;

   type Input_Pin (Id : Pin_Id) is limited record
      Claimed : Boolean := False;
   end record;

   function Is_Claimed (P : Output_Pin) return Boolean is (P.Claimed);
   function Is_Claimed (P : Input_Pin) return Boolean is (P.Claimed);
end Keel.GPIO.Fake;
