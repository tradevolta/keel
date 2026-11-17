--  What to send back for one character
type Action is
  (Nothing,   --  send nothing
   Echo,      --  send the character
   Rub_Out,   --  send BS, space, BS
   Line_End,  --  send CR LF: the line is done
   Cancel,    --  send "^C" and CR LF: the line is gone
   Ring);     --  send Bell: the line is full

procedure Feed (Ed : in out Editor; C : Character; Act : out Action)
  with Pre  => not Is_Done (Ed),
       Post =>
         (case Act is
            when Echo =>
              C in ' ' .. '~'
              and then Text (Ed) = Text (Ed'Old) & C,
            when Rub_Out =>
              Length (Ed'Old) > 0
              and then Text (Ed)
                       = Text (Ed'Old) (1 .. Length (Ed'Old) - 1),
            when Line_End =>
              Is_Done (Ed) and then Text (Ed) = Text (Ed'Old),
            when Cancel =>
              Length (Ed) = 0,
            when Ring | Nothing =>
              Text (Ed) = Text (Ed'Old))
         and then (if Act /= Line_End then not Is_Done (Ed));
