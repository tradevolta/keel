--  What a console provides: Keel.CLI and Keel.Log use only this
generic
   --  Send Text. It may wait while there is no room for it.
   with procedure Write (Text : String);
   --  The next character received, if there is one. Never waits.
   with procedure Read (C : out Character; Got : out Boolean);
   --  Characters Write would take now without waiting
   with function Space return Natural;
package Text_Signature is
   pragma Warnings (Off, Write);
   pragma Warnings (Off, Read);
   pragma Warnings (Off, Space);
end Text_Signature;
