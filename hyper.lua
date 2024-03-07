local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

M.chat_apps = {}

M.vpn_apps = { "ClearVPN", "NordVPN" }

function M.setup()
	for _, definition in ipairs(M.bindings()) do
		local key, app, apps = table.unpack(definition)
		--- @type function[]
		local args = {}
		if apps ~= nil then
			args = { M.chooser(app, apps) }
		else
			args = { M.open(app) }
		end
		hs.hotkey.bind(M.hyper, key, table.unpack(args))
	end
end

function M.bindings()
	--- @type { [1]: string, [2]: string|function, [3]: string[]? }[]
	return {
		{ "1", "1Password" },
		{ "b", "Firefox" },
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Mail" },
		{ "f", "Figma" },
		{ "h", "Hammerspoon" },
		{ "l", "Timemator" },
		{
			"m",
			"Messages",
			{

				"Messages",
				"Telegram",
				"WhatsApp",
				"Mail",
				"Discord",
				"Element",
				"Messenger",
				"Slack",
			},
		},
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

function M.chooser(defaultApp, apps)
	local isRepeating = false

	local chooser
	chooser = hs.chooser.new(function(choice)
		isRepeating = false
		if choice == nil or choice.text == nil then return end
		M.open(choice.text)()
		chooser:query(nil)
	end)

	local choices = {}
	for i, v in ipairs(apps) do
		choices[i] = { text = v }
	end
	chooser:choices(choices)

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
