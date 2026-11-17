procedure Poll is
   use Keel.CLI.Lines;
   C   : Character;
   Got : Boolean;
   Act : Action;
begin
   loop
      Console.Read (C, Got);
      exit when not Got;
      Feed (Ed, C, Act);
      case Act is
         when Nothing  => null;
         when Echo     => Put ([C]);
         when Rub_Out  => Put (BS & ' ' & BS);
         when Ring     => Put ([Bell]);
         when Cancel   => Put ("^C" & CRLF & Prompt);
         when Line_End =>
            Put (CRLF);
            Run (Text (Ed));
            Clear (Ed);
            Put (Prompt);
            --  One line a call, so the main loop gets a turn
            exit;
      end case;
   end loop;
end Poll;
