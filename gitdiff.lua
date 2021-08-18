-- mod-version:1
local gitdiff = {}

-- liquidev is a genius
local function extract_hunks(input)
	local hunks = {}
	local current_hunk = {}

	local function end_hunk(new_line)
		if #current_hunk > 0 then
			table.insert(hunks, current_hunk)
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
	if diff == nil then return {} end
	local changed_lines = {}
	local hunks = extract_hunks(diff)
	-- iterate over hunks
	for i, hunk in pairs(hunks) do
		local hunk_start = hunk[1]:match("@@%s+-%d+,%d+%s++(%d-),%d+%s+@@")
		hunk_start = tonumber(hunk_start)
		if  hunk_start == nil then
			goto continue
		end

		hunk_start = hunk_start - 1

		-- remove hunk header
		hunk[1] = hunk[1]:gsub("@@%s+-%d+,%d+%s++%d+,%d+%s+@@", "")

		local current_line = hunk_start
		for ii, line in pairs(hunk) do
			if line:match("^-") then
				table.insert(changed_lines, {
					line_number = current_line,
					change_type = "deletion"
				})
				-- do not add to the current line
				goto continue1
			end

			if line:match("^+") then
				table.insert(changed_lines, {
					line_number = current_line,
					change_type = "addition"
				})
				for iii, lline in pairs(changed_lines) do
					if lline.line_number == current_line and lline.change_type == "deletion" then
						table.insert(changed_lines, {
							line_number = current_line,
							change_type = "modification"
						})
					end
				end
			end
			current_line = current_line + 1
			::continue1::
		end
		::continue::
	end

	local indexed_changed_lines = {}
	for i, line in pairs(changed_lines) do
		indexed_changed_lines[line.line_number] = line.change_type
	end

	return indexed_changed_lines
end

return gitdiff
