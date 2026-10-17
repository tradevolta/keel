--  The minimum Arm IMAGE_DEF (RP2350 datasheet, 5.9.5.1): a block
--  start marker, an IMAGE_TYPE item (executable, Secure, Arm,
--  RP2350), a LAST item, a link to itself and an end marker.
Image_Def : constant Word_Array (1 .. 5) :=
  [16#FFFF_DED3#, 16#1021_0142#, 16#0000_01FF#,
   16#0000_0000#, 16#AB12_3579#]
  with Export, External_Name => "keel_image_def",
       Linker_Section => ".keel.image_def";
