local gitdiff = {}

-- liquidev is a genius
local function extract_hunks(input)
	local hunks = {}
	local current_hunk = {}

	local function end_hunk(new_line)
		if #current_hunk > 0 then
			table.insert(hunks, table.concat(current_hunk))
			current_hunk = {new_line}
		end
	end

	for line in input:gmatch("(.-)\n") do
		if line:match("^@") then
			end_hunk(line)
		else
			table.insert(current_hunk, line)
		end
	end

	-- add the last hunk to the table
	end_hunk("")

	return hunks
end

-- this will only work on single-file diffs
function gitdiff.changed_lines(diff)
	local changed_lines = {}
	local hunks = extract_hunks(diff)
	-- iterate over hunks
	for i, hunk in pairs(hunks) do
		local hunk_start = hunk:match("@@%s+-%d+,%d+%s++(%d-),%d+%s+@@")

		if  hunk_start == nil then
			print(hunk)
			goto continue
		end
		print()
		::continue::
	end
	
	return changed_lines
end

return gitdiff
