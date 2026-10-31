type Port_Id is (A, B, C, D, E, F, G);
type Pin_Number is range 0 .. 15;

type Output_Pin (Port : Port_Id; Pin : Pin_Number) is
  limited private;
type Input_Pin (Port : Port_Id; Pin : Pin_Number) is
  limited private;
