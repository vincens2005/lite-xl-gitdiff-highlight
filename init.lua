-- mod-version:1
local core = require "core"
local config = require "core.config"
local DocView = require "core.docview"
local Doc = require "core.doc"
local common = require "core.common"
local style = require "core.style"
local gitdiff = require "plugins.gitdiff_highlight.gitdiff"

-- vscode defaults
style.gitdiff_addition = {common.color "#587c0c"}
style.gitdiff_modification = {common.color "#0c7d9d"}
style.gitdiff_deletion = {common.color "#94151b"}

style.gitdiff_width = 3

local last_doc_lines = 0
-- test diff
local current_diff = {}
local current_doc_name = nil
local diffs = {}

local function update_diff()
	-- TODO check if file is in git repo by using git ls-files --error-unmatch <file>
	-- TODO run the command git diff HEAD <file>
	core.log("todo haha")
end

local function set_doc(doc_name)
	if current_diff ~= {} and current_doc_name ~= nil then
		diffs[current_doc_name] = current_diff
	end
	current_doc_name = doc_name
	if diffs[current_doc_name] ~= nil then
		current_diff = diffs[current_doc_name]
	else
		current_diff = {}
	end
	update_diff()
end

local function gitdiff_padding(dv)
	return style.padding.x * 1.5 + dv:get_font():get_width(#dv.doc.lines)
end

local old_docview_gutter = DocView.draw_line_gutter
function DocView:draw_line_gutter(idx, x, y)
	old_docview_gutter(self, idx, x, y)

	if current_diff[idx] == nil then
		return
	end

	local color = nil

	if current_diff[idx] == "addition" then
		color = style.gitdiff_addition
	elseif current_diff[idx] == "modification" then
		color = style.gitdiff_modification
	else
		color = style.gitdiff_deletion
	end

	-- add margin in between highlight and text
	x = x + gitdiff_padding(self)

	local yoffset = self:get_line_text_y_offset()
	renderer.draw_rect(x, y + yoffset, style.gitdiff_width, self:get_line_height(), color)
end

local old_gutter_width = DocView.get_gutter_width
function DocView:get_gutter_width()
	return old_gutter_width(self) + style.padding.x
end

local old_text_change = Doc.on_text_change
function Doc:on_text_change(type)
	local line, col = self:get_selection()
	if current_diff[line] == "addition" then goto end_of_function end
	-- TODO figure out how to detect an addition
	if type == "insert" or (type == "remove" and #self.lines == last_doc_lines) then
		current_diff[line] = "modification"
	elseif type == "remove" then
		current_diff[line] = "deletion"
	end
	::end_of_function::
	last_doc_lines = #self.lines
	return old_text_change(self, type)
end

local old_docview_update = DocView.update
function DocView:update()
	local filename = self.doc.abs_filename or ""
	if current_doc_name ~= filename and filename ~= "---" and core.active_view.doc == self.doc then
		set_doc(filename)
	end

	return old_docview_update(self)
end
