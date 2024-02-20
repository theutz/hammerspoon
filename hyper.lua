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
	{ "v", "Neovide" },
}

function M.setup()
	for _, definition in ipairs(M.hyper_bindings) do
		local key, app = table.unpack(definition)
		local fn = function()
			local curr = hs.application.find(app)
			if curr and curr.isFrontmost and curr:isFrontmost() then
				curr:hide()
				return
			end
			hs.application.launchOrFocus(app)
		end
		if type(app) == "function" then fn = app end
		hs.hotkey.bind(M.hyper, key, fn)
	end
end

return M
