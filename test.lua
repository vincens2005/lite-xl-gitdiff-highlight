-- this file tests the script
local gitdiff = require "gitdiff"

local input = io.read("*a")
local lines = gitdiff.changed_lines(input)
print("testing first line...")
print(lines[1].line_number)
print(lines[1].change_type)
print()
print("testing all lines...")
for i, line in pairs(lines) do
	print("line ".. line.line_number .. " - " .. line.change_type)
end
