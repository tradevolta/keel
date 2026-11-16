type Retained_Index is range 0 .. 7;
type Retained_Words is array (Retained_Index) of Word;

function Retained (I : Retained_Index) return Word;
procedure Retain (I : Retained_Index; Value : Word);
