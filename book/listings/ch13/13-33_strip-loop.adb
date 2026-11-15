Board.Initialize;
Find_Probes;
if Count = 0 then
   Put_Line ("thermo: no DS18B20 found");
end if;

Next := Now;
loop
   if Count > 0 then
      Sensor.Start_Conversion (Probes, Stat);
      if Stat = Ok then
         Wait_Until (Now + Sensor.Conversion_Time);
      end if;
      for P in Probe loop
         if Stat = Ok then
            Sensor.Read (Probes, ROMs (P), Raw, Stat);
         end if;
         if Stat = Ok and then Raw in Sensor.Rated then
            Temps (P) := Sensor.To_Celsius (Raw);
         end if;
      end loop;
      if Stat = Ok then
         Put_Line ("thermo: A" & Temps (A)'Image & " C, B"
                   & Temps (B)'Image & " C");
      else
         Put_Line ("thermo: read: " & Stat'Image);
      end if;
   end if;

   Show (LEDs, Thermo.Strip_For (Temps (A), Temps (B)), Level,
         Shown);
   if Shown /= Keel.Ok then
      Put_Line ("thermo: strip: " & Shown'Image);
   end if;

   Next := Next + Milliseconds (1_000);
   Wait_Until (Next);
end loop;
