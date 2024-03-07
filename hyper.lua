local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

M.chat_apps = {
	"Messages",
	"Telegram",
	"WhatsApp",
	"Mail",
	"Discord",
	"Element",
	"Messenger",
	"Slack",
}

function M.setup()
	M.setupVpnChooser()

	for _, definition in ipairs(M.bindings()) do
		local key, app, helper = table.unpack(definition)
		--- @type function[]
		local args = {}
		if helper and type(helper) == "function" then
			args = { helper(app) }
		else
			args = { M.open(app) }
		end
		hs.hotkey.bind(M.hyper, key, table.unpack(args))
	end
end

function M.bindings()
	--- @type { [1]: string, [2]: string|function, [3]: function? }[]
	return {
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Mail" },
		{ "f", "Figma" },
		{ "h", "Hammerspoon" },
		{ "l", "Timemator" },
		{ "m", "Messages", M.chatFns },
		{ "n", "Notion" },
		{ "p", "Spotify" },
		{ "s", "Slack" },
		{ "t", "WezTerm" },
		{ "u", "Due" },
		{ "i", "Neovide" },
		{ "v", function() M.vpn_chooser:show() end },
		{ "z", "zoom.us" },
	}
end

M.vpn_chooser = nil

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

function M.chatFns(defaultApp)
	local chooser = hs.chooser.new(function(choice)
		if choice == nil or choice.text == nil then return end
		M.open(choice.text)()
	end)

	local choices = {}
	for i, v in ipairs(M.chat_apps) do
		choices[i] = { text = v }
	end
	chooser:choices(choices)

	local isRepeating = false

	local pressedfn = function() end
	local releasedfn = function()
		if not isRepeating then M.open(defaultApp)() end
	end
	local repeatfn = function()
		if chooser:isVisible() then return end
		isRepeating = true
		chooser:show()
	end

	return pressedfn, releasedfn, repeatfn
end

return M
