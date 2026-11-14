--  round (65_536 * (B / 255) ** 2.2), worked out once on a
--  computer: the eye's response is close to a power law, so equal
--  steps of B look like equal steps of brightness
Table : constant array (Brightness) of Natural range 0 .. 65_536 :=
  [
   0, 0, 2, 4, 7, 11, 17, 24,
   32, 42, 53, 65, 79, 94, 111, 129,
   148, 169, 192, 216, 242, 270, 299, 330,
   362, 396, 432, 469, 508, 549, 591, 635,
