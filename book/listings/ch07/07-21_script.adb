Script : constant array (1 .. 4) of Round :=
  [(Late => [A => 213, B => 260], others => <>),
   (Early => [A => Never, B => 400], others => <>),
   (Late => [A => 150, B => 150], others => <>),
   (others => <>)];

--  A press: down, three bounces, held 120 ms, one bounce up
Contact : constant array (0 .. 122) of Level :=
  [1 | 3 | 120 | 122 => High, others => Low];
