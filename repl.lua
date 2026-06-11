-- replay REPL inputs -> numbered trace with real outputs.
-- usage: lua etc/repl.lua FILE [start] [preload]
--   FILE     lines of lua; "#### x" lines pass through verbatim
--   start    first event number (default 1)
--   preload  if given, quietly require lib/lull/lapps first
local file, n, pre = arg[1], (tonumber(arg[2]) or 1) - 1, arg[3]
if pre then
  _G.l = require"lib"; _G.m = require"lull"; _G.a = require"lapps"
end
for s in io.lines(file) do
  if s:match"^####" or s == "" then
    print(s)
  else
    n = n + 1
    io.write(("[%d]> %s\n"):format(n, s))
    local f = s:match";$" and load(s)
              or load("return " .. s) or load(s)
    local res = {pcall(f)}
    if res[1] then
      if #res > 1 then
        local out = {}
        for i = 2, #res do out[1+#out] = tostring(res[i]) end
        print(table.concat(out, "\t")) end
    else
      print("ERROR: " .. tostring(res[2])) end end end
print(("-- next event: [%d]"):format(n + 1))
