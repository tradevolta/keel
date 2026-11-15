--  SPDX-License-Identifier: Apache-2.0
package body Sim_PIO is

   function Run
     (P          : Program;
      Start      : Address;
      Words      : Word_Array;
      Pull_Bits  : Positive;
      Open_Drain : Boolean;
      Devices    : Hold_Array;
      Max_Cycles : Positive := 5_000) return Event_Array
   is
      Log    : Event_Array (1 .. 4_000);
      Last   : Natural := 0;
      PC     : Address := Start;
      X      : Word := 0;
      OSR    : Word := 0;
      Left   : Natural := 0;   --  bits still in the OSR
      Next   : Positive := Words'First;
      Dir    : Boolean := False;  --  PINDIRS: True drives low
      Side   : Boolean := False;  --  the side-set level
      Level  : Boolean := True;   --  the pin as last logged
      Cycle  : Natural := 0;
      Side_Field : constant Natural := P.Side_Bits;

      procedure Log_Event (Kind : Event_Kind; Value : Boolean := False)
      is
      begin
         Last := Last + 1;
         Log (Last) := (Cycle, Kind, Value);
      end Log_Event;

      function Held return Boolean is
        (for some D of Devices => Cycle in D.From .. D.To);

      --  The pin's level in this cycle; log each change
      procedure Update_Pin is
         Now : constant Boolean :=
           (if Open_Drain then not Dir and then not Held else Side);
      begin
         if Now /= Level then
            Level := Now;
            Log_Event ((if Now then Pin_High else Pin_Low));
         end if;
      end Update_Pin;

      I      : Instruction;
      Op     : Natural;
      Field  : Natural;
      Idle   : Natural;
      Arg    : Natural;
      Jumped : Boolean;
   begin
      if not Open_Drain then
         Level := False;
      end if;
      loop
         exit when Cycle >= Max_Cycles;
         I := P.Code (PC);
         Op := Natural (I / 2**13);
         Field := Natural (I / 2**8 mod 32);
         Idle := Field mod 2**(5 - Side_Field);
         if Side_Field > 0 then
            Side := Field / 2**(5 - Side_Field) mod 2 = 1;
         end if;
         Arg := Natural (I mod 256);
         Jumped := False;
         case Op is
            when 0 =>  --  JMP
               declare
                  Cond : constant Natural := Arg / 32;
                  Take : Boolean;
               begin
                  case Cond is
                     when 0 => Take := True;
                     when 1 => Take := X = 0;
                     when 2 =>
                        Take := X /= 0;
                        X := X - 1;
                     when others => raise Program_Error;
                  end case;
                  if Take then
                     PC := Address (Arg mod 32);
                     Jumped := True;
                  end if;
               end;
            when 3 =>  --  OUT X, n (autopull)
               if Left = 0 then
                  if Next > Words'Last then
                     Update_Pin;
                     Log_Event (Stall);
                     exit;
                  end if;
                  OSR := Words (Next);
                  Next := Next + 1;
                  Left := Pull_Bits;
               end if;
               if Pull_Bits = 1 then
                  X := OSR mod 2;
                  OSR := OSR / 2;
               else
                  X := OSR / 2**31;
                  OSR := OSR * 2;
               end if;
               Left := Left - 1;
            when 7 =>  --  SET
               case Arg / 32 is
                  when 4 => Dir := Arg mod 32 = 1;
                  when 1 => X := Word (Arg mod 32);
                  when others => raise Program_Error;
               end case;
            when 2 =>  --  IN PINS or NULL, 1 (autopush)
               Update_Pin;
               Log_Event
                 (Sample, (if Arg / 32 = 0 then Level else False));
            when 5 =>  --  MOV Y, Y
               null;
            when others =>
               raise Program_Error;
         end case;
         --  The instruction's cycle, then its idle ones
         for N in 0 .. Idle loop
            Update_Pin;
            Cycle := Cycle + 1;
         end loop;
         if not Jumped then
            PC := (if PC = P.Wrap then P.Wrap_Target else PC + 1);
         end if;
      end loop;
      return Log (1 .. Last);
   end Run;
end Sim_PIO;
