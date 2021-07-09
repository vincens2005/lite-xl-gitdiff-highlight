-- this file tests the script
local gitdiff = require "gitdiff"

local input = io.read("*a")
local lines = gitdiff.changed_lines(input)
print(lines[1])
