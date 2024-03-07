local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

--- @type { [1]: string, [2]: string|string[] }[]
M.bindings = {
	{ "1", "1Password" },
	{ "b", { "Firefox", "Vivaldi", "Safari", "Google Chrome" } },
	{ "c", "Calendar" },
	{ "d", "Dash" },
	{ "e", "Neovide" },
	{ "f", "Figma" },
	{ "h", "Hammerspoon" },
	{ "l", "Timemator" },
	{
		"m",
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
	{ "n", { "Notion", "Notes" } },
	{ "p", "Spotify" },
	{ "s", "Slack" },
	{ "t", { "WezTerm", "iTerm 2", "Kitty" } },
	{ "u", "Due" },
	{ "i", "Neovide" },
	{ "v", { "ClearVPN", "NordVPN" } },
	{ "z", "zoom.us" },
}

function M.setup()
	for _, definition in ipairs(M.bindings) do
		local key, apps = table.unpack(definition)
		local keySpec = { M.hyper, key }
		if type(apps) == "table" and #apps > 1 then
			local app = apps[1]
			local apps = apps
			hs.hotkey.bindSpec(keySpec, M.chooser(app, apps))
		else
			local app
			if type(apps) == "table" and #apps == 1 then
				app = apps[1]
			else
				app = apps
			end
			hs.hotkey.bindSpec(keySpec, M.open(app))
		end
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
