local gitdiff = {}

-- this will only work on single-file diffs
function gitdiff.changed_lines(diff)
	local first_hunk_start = diff:match("@@%s+-%d+,%d+%s++(%d-),%d+%s+@@")
	-- we are only interested in the stuff after the hunk
	diff = diff:match("@@%s+-%d+,%d+%s++%d+,%d+%s+@@(.*)")
	
	print(first_hunk_start)
	local changed_lines = {}
	return changed_lines
end

return gitdiff
