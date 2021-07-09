-- this file tests the script
local gitdiff = require "gitdiff"

local input = io.read("*a")
local lines = gitdiff.changed_lines(input)
print(lines[1].line_number)
print(lines[1].change_type)

for i, line in pairs(lines) do
	print(line.change_type)
	print(line.line_number)
end
