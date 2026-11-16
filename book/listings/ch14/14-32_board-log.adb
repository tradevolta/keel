procedure Load (L : out Sentinel_Log.Log; Found : out Boolean) is
   W : Sentinel_Log.Words;
begin
   for I in W'Range loop
      W (I) := Sentinel_Log.Word
        (Power.Retained (Power.Retained_Index (I)));
   end loop;
   Found := Sentinel_Log.Valid (W);
   L := (if Found then Sentinel_Log.Decode (W) else (others => <>));
end Load;

procedure Store (L : Sentinel_Log.Log) is
   W : constant Sentinel_Log.Words := Sentinel_Log.Encode (L);
begin
   for I in W'Range loop
      Power.Retain (Power.Retained_Index (I), Power.Word (W (I)));
   end loop;
end Store;
