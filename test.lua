-- this file tests the script
local gitdiff = require "gitdiff"

local input = io.read("*a")
local lines = gitdiff.changed_lines(input) -- test

print("testing first line...")
print(lines[1])
print()
print("testing all lines...")
for i, line in pairs(lines) do
	print("line ".. i .. " - " .. line)
end
