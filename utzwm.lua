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

hs.hotkey.bind(mods, "x", function()
	local grid = hs.grid.getGrid()
	hs.grid.setGrid("6x4")
	hs.grid.show(function()
		hs.grid.setGrid(grid)
	end)
end)

hs.hotkey.bind(mods, "h", function()
	---@type hs.window
	local win = hs.window.frontmostWindow()
	local current = hs.grid.get(win)

	local initial = hs.geometry.new("0,0 6x8")

	---@type table
	local big = initial:copy()
	big.w = big.w + 2

	---@type table
	local small = initial:copy()
	small.w = small.w - 2

	local target = initial

	if initial == current then
		target = small
	elseif current == small then
		target = big
	end

	hs.grid.set(win, target)
end)

hs.hotkey.bind(mods, "l", function()
	local win = hs.window.frontmostWindow()
	local current = hs.grid.get(win)

	local initial = hs.geometry.new("6,0 6x8")

	---@type table
	local big = initial:copy()
	big.w = big.w + 2
	big.x = big.x - 2

	---@type table
	local small = initial:copy()
	small.w = small.w - 2
	small.x = small.x + 2

	local target = initial

	if current == initial then
		target = small
	elseif current == small then
		target = big
	end

	hs.grid.set(win, target)
end)

hs.hotkey.bind(mods, "k", function()
	local win = hs.window.frontmostWindow()
	local current = hs.grid.get(win)

	local initial = hs.geometry.new("0,0 12x4")

	---@type table
	local right_quarter = initial:copy()
	right_quarter.w = 6
	right_quarter.x = 6

	---@type table
	local left_quarter = initial:copy()
	left_quarter.w = 6
	left_quarter.x = 0

	---@type table
	local right_sixth = initial:copy()
	right_sixth.w = 4
	right_sixth.x = 0

	---@type table
	local center_sixth = initial:copy()
	center_sixth.w = 4
	center_sixth.x = 4

	---@type table
	local left_sixth = initial:copy()
	left_sixth.w = 4
	left_sixth.x = 8

	local target = initial

	if current == initial then
		target = left_quarter
	elseif current == left_quarter then
		target = right_quarter
	elseif current == right_quarter then
		target = right_sixth
	elseif current == right_sixth then
		target = center_sixth
	elseif current == center_sixth then
		target = left_sixth
	end

	hs.grid.set(win, target)
end)

hs.hotkey.bind(mods, "j", function()
	local win = hs.window.frontmostWindow()
	local current = hs.grid.get(win)

	local initial = hs.geometry.new("0,4 12x4")

	---@type table
	local right_quarter = initial:copy()
	right_quarter.w = 6
	right_quarter.x = 6

	---@type table
	local left_quarter = initial:copy()
	left_quarter.w = 6
	left_quarter.x = 0

	---@type table
	local right_sixth = initial:copy()
	right_sixth.w = 4
	right_sixth.x = 0

	---@type table
	local center_sixth = initial:copy()
	center_sixth.w = 4
	center_sixth.x = 4

	---@type table
	local left_sixth = initial:copy()
	left_sixth.w = 4
	left_sixth.x = 8

	local target = initial

	if current == initial then
		target = left_quarter
	elseif current == left_quarter then
		target = right_quarter
	elseif current == right_quarter then
		target = right_sixth
	elseif current == right_sixth then
		target = center_sixth
	elseif current == center_sixth then
		target = left_sixth
	end

	hs.grid.set(win, target)
end)

hs.hotkey.bind(mods, "return", function()
	local win = hs.window.frontmostWindow()
	local current = hs.grid.get(win)

	local initial = hs.geometry.new({ 0, 0, gridSize.w, gridSize.h })

	---@type table
	local two_thirds = initial:copy()
	two_thirds.w = two_thirds.w - 4
	two_thirds.x = two_thirds.x + 2

	---@type table
	local half = initial:copy()
	half.w = half.w - 6
	half.x = half.x + 3

	---@type table
	local third = initial:copy()
	third.w = third.w - 8
	third.x = third.x + 4

	local target = initial

	if current == initial then
		target = two_thirds
	elseif current == two_thirds then
		target = half
	elseif current == half then
		target = third
	end

	hs.grid.set(win, target)
end)

hs.hotkey.bind(mods, "space", function()
	local win = hs.window.frontmostWindow()
	---@type table
	local frame = win:centerOnScreen():frame()
	frame.y = frame.y + gridMargin.h - 3 -- not sure why we need this 3, but we do
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
