Glyph_Size : constant := 8;
subtype Glyph_Index is Natural range 0 .. Glyph_Size - 1;

type Glyph is array (Glyph_Index) of Unsigned_8;
subtype Printable is Character range ' ' .. '~';
type Glyph_Table is array (Printable) of Glyph;

--  Pixel (Row, Column) of G is set
function Is_Set (G : Glyph; Row, Column : Glyph_Index) return Boolean
is ((Shift_Right (G (Row), Column) and 1) = 1);

--  The glyph for C; a character the font lacks draws as '?'
function Glyph_Of (C : Character) return Glyph;
