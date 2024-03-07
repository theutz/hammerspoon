local log = require "log"

local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

M.hyper_bindings = {
	{ "1", "1Password" },
	{ "b", "Arc" },
	{ "c", "Calendar" },
	{ "d", "Dash" },
	{ "e", "Mail" },
	{ "f", "Figma" },
	{ "g", function() M.messaging_chooser:show() end },
	{ "h", "Hammerspoon" },
	{ "l", "Timemator" },
	{ "m", "Messages" },
	{ "n", "Notion" },
	{ "p", "Spotify" },
	{ "s", "Slack" },
	{ "t", "WezTerm" },
	{ "u", "Due" },
	{ "i", "Neovide" },
	{ "v", function() M.vpn_chooser:show() end },
	{ "z", "zoom.us" },
}

M.vpn_chooser = nil

function M.setup()
	M.setupVpnChooser()
	M.setupMessagingChooser()

	for _, definition in ipairs(M.hyper_bindings) do
		local key, app = table.unpack(definition)
		hs.hotkey.bind(M.hyper, key, M.open(app))
	end
end

function M.open(app)
	local fn = function()
		local curr = hs.application.find(app)
		if curr and type(curr.isFrontmost) == "function" and curr:isFrontmost() then
			if curr:hide() then return end
			local name
			if app and app.name then
				name = app.name
			elseif type(app) == "string" then
				name = app
			end
			if name then curr:selectMenuItem("Hide " .. name) end
			return
		end
		hs.application.launchOrFocus(app)
	end
	if type(app) == "function" then fn = app end
	return fn
end

function M.setupVpnChooser()
	local chooser = hs.chooser.new(function(choice)
		if choice == nil or choice.text == nil then return end
		M.open(choice.text)()
		M.vpn_chooser:query(nil)
	end)
	chooser:choices {
		{ text = "ClearVPN" },
		{ text = "NordVPN" },
	}
	M.vpn_chooser = chooser
end

function M.setupMessagingChooser()
	local chooser = hs.chooser.new(function(choice)
		if choice == nil or choice.text == nil then return end
		M.open(choice.text)()
		M.messaging_chooser:query(nil)
	end)
	chooser:choices {
		{ text = "Telegram" },
		{ text = "WhatsApp" },
		{ text = "Discord" },
		{ text = "Element" },
		{ text = "Messenger", subText = "Facebook" },
		{ text = "Messages", subText = "macOS" },
		{ text = "Slack" },
	}
	M.messaging_chooser = chooser
end

return M
