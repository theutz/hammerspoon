local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

M.hyper_bindings = {
	{ "1", "1Password" },
	{ "b", "Arc" },
	{ "c", "Calendar" },
	{ "d", "Dash" },
	{ "e", "Mail" },
	{ "f", "Figma" },
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
}

M.vpn_chooser = nil

function M.setup()
	M.setupVpnChooser()
	for _, definition in ipairs(M.hyper_bindings) do
		local key, app = table.unpack(definition)
		hs.hotkey.bind(M.hyper, key, M.openOrFocus(app))
	end
end

function M.openOrFocus(app)
	local fn = function()
		local curr = hs.application.find(app)
		if curr and curr.isFrontmost and curr:isFrontmost() then
			curr:hide()
			return
		end
		hs.application.launchOrFocus(app)
	end
	if type(app) == "function" then fn = app end
	return fn
end

function M.setupVpnChooser()
	local vpn_chooser = hs.chooser.new(function(choice)
		if choice == nil or choice.text == nil then return end
		M.openOrFocus(choice.text)()
		M.vpn_chooser:query(nil)
	end)
	vpn_chooser:choices {
		{ text = "ClearVPN" },
		{ text = "NordVPN" },
	}
	M.vpn_chooser = vpn_chooser
end

return M
