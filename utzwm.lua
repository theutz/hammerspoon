local log = require("log")
local wf = hs.window.filter

local mods = { "ctrl", "alt", "cmd" }

spoon.SpoonInstall:andUse("WindowScreenLeftAndRight", {
	hotkeys = {
		screen_left = { mods, "[" },
		screen_right = { mods, "]" },
	},
})

local gridSize = hs.geometry.size(12, 8) or {}
local gridMargin = hs.geometry.size(16, 16) or {}

hs.grid.setGrid(gridSize).setMargins(gridMargin)

---@type ((string | string[])[])[]
local definitions = {
	{ "h", { "0,0 6x8", "0,0 9x8", "0,0 3x8" } },
	{ "j", { "0,4 12x4", "0,4 6x4", "6,4 12x4", "0,4 4x4", "4,4 4x4", "8,4 4x4" } },
	{ "k", { "0,0 12x4", "0,0 6x4", "6,0 12x4", "0,0 4x4", "4,0 4x4", "8,0 4x4" } },
	{ "l", { "6,0 6x8", "3,0 9x8", "9,0 3x8" } },
	{ "u", { "0,0 6x4" } },
	{ "i", { "6,0 6x4" } },
	{ "m", { "6,4 6x4" } },
	{ "n", { "0,4 6x4" } },
	{ "return", { "0,0 12x8" } },
}

for _, def in ipairs(definitions) do
	local key, sizes = table.unpack(def)
	---@cast key string
	---@cast sizes string[]

	hs.hotkey.bind(mods, key, function()
		local win = hs.window.frontmostWindow()
		local current = hs.grid.get(win)

		for index, size in ipairs(sizes) do
			---@cast sizes hs.geometry[]
			sizes[index] = hs.geometry:new(size)
		end

		local size = sizes[1]

		for index, value in ipairs(sizes) do
			if current and current:equals(value) then
				size = sizes[index + 1] or size
			end
		end

		hs.grid.set(win, size)
	end)
end

-- Activate grid chooser
hs.hotkey.bind(mods, "x", function()
	local grid = hs.grid.getGrid()
	hs.grid.setGrid("6x4")
	hs.grid.show(function()
		hs.grid.setGrid(grid)
	end)
end)

-- Center on Screen
hs.hotkey.bind(mods, "space", function()
	local win = hs.window.frontmostWindow()
	---@type table
	local frame = win:centerOnScreen():frame()
	frame.y = frame.y - gridMargin.h - 3 -- not sure why we need this 3, but we do
	win:move(frame)
end)

-- AutoStashApps = wf.new({
--   "Messages",
--   "Telegram",
--   "WhatsApp",
--   "Discord",
--   "Slack",
--   "Spotify",
--   "Hammerspoon",
--   "Surfshark",
--   "Calendar",
--   "Reeder",
--   "1Password",
-- })

-- AutoStashApps:subscribe({ wf.windowVisible, wf.windowFocused }, function(win)
--   ---@type hs.screen | nil
--   local screen = nil
--   local g = hs.geometry.new({ 1, 1, 10, 6 })
--   if #hs.screen.allScreens() > 1 then
--     screen = hs.screen.primaryScreen()
--   end
--   hs.grid.set(win, g, screen)
-- end)

-- AutoStashApps:subscribe(wf.windowUnfocused, function(win)
--   local primaryScreen = hs.screen.primaryScreen()
--   ---@type hs.screen | nil
--   local screen = nil
--   local g = hs.geometry.new({ 0, 0, 12, 8 })
--   if #hs.screen.allScreens() > 1 then
--     if win:screen() == primaryScreen then
--       screen = primaryScreen:next()
--     end
--     hs.grid.set(win, g, screen)
--   else
--     win:application():hide()
--   end
-- end)
