--  SPDX-License-Identifier: Apache-2.0
--  Read a memory.toml. Raises Map_Error for a file that is not TOML,
--  Constraint_Error for a missing key or a value out of range.
function Memory_Map.From_TOML (File_Name : String) return Board;
