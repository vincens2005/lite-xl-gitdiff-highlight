-- mod-version:1

local DocView = require "core.docview"
local common = require "core.common"
local style = require "core.style"
local gitdiff = require "plugins.gitdiff_highlight.gitdiff"

style.gitdiff_addition = {common.color "#587c0c"} -- vscode default
style.gitdiff_width = 3

local function gitdiff_padding(dv)
	return style.padding.x * string.len(tostring(#dv.doc.lines)) + style.padding.x / 2
end

local old_docview_gutter = DocView.draw_line_gutter
function DocView:draw_line_gutter(idx, x, y)
	old_docview_gutter(self, idx, x, y)

	-- add margin in between highlight and text
	x = x + gitdiff_padding(self)

	local yoffset = self:get_line_text_y_offset()
	renderer.draw_rect(x, y + yoffset, style.gitdiff_width, self:get_line_height(), style.gitdiff_addition)
end

local old_gutter_width = DocView.get_gutter_width
function DocView:get_gutter_width()
	return old_gutter_width(self) + style.padding.x / 2 + style.padding.x / 2
end
