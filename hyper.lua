local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }

M.bindings = function()
	--- @type { [1]: string, [2]: string|string[]|function?, [3]: function?, [4]: function? }[]
	return {
		{ "1", "1Password" },
		{ "b", { "Firefox", "Vivaldi", "Safari", "Google Chrome" } },
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Neovide" },
		{ "f", "Figma" },
		{ "h", "Hammerspoon" },
		{ "l", M.launchTimematorOverview },
		{ "m", { "Messages", "Telegram", "WhatsApp", "Mail", "Discord", "Element", "Messenger", "Slack" } },
		{ "n", { "Notion", "Notes" } },
		{ "p", "Spotify" },
		{ "s", "Slack" },
		{ "t", { "WezTerm", "iTerm 2", "Kitty" } },
		{ "u", "Due" },
		{ "i", "Neovide" },
		{ "v", { "ClearVPN", "NordVPN" } },
		{ "z", "zoom.us" },
	}
end

function M.setup()
	for _, definition in ipairs(M.bindings()) do
		local key, apps, releasedfn, repeatfn = table.unpack(definition)
		local keySpec = { M.hyper, key }
		if type(apps) == "table" and #apps > 1 then
			local app = apps[1]
			hs.hotkey.bindSpec(keySpec, M.chooser(app, apps))
		elseif type(apps) == "function" or apps == nil then
			local pressedfn = apps
			hs.hotkey.bindSpec(keySpec, pressedfn, releasedfn, repeatfn)
		else
			local app
			if type(apps) == "table" and #apps == 1 then
				app = apps[1]
			else
				app = apps
			end
			hs.hotkey.bindSpec(keySpec, M.opener(app))
		end
	end
end

function M.opener(appName)
	local app = hs.application.find(appName, true)
	local fn = function()
		if app and type(app.isFrontmost) == "function" and app:isFrontmost() then
			if app:hide() then return end
			local name
			if appName and appName.name then
				name = appName.name
			elseif type(appName) == "string" then
				name = appName
			end
			if name then app:selectMenuItem("Hide " .. name) end
			return app
		end
		return hs.application.open(appName)
	end
	if type(appName) == "function" then fn = appName end
	return fn
end

function M.chooser(defaultApp, apps)
	local isRepeating = false

	local chooser
	chooser = hs.chooser.new(function(choice)
		isRepeating = false
		if choice == nil or choice.text == nil then return end
		M.opener(choice.text)()
		chooser:query(nil)
	end)

	local choices = {}
	for i, v in ipairs(apps) do
		choices[i] = { text = v }
	end
	chooser:choices(choices)

	local pressedfn = function() end
	local releasedfn = function()
		if not isRepeating then M.opener(defaultApp)() end
	end
	local repeatfn = function()
		if chooser:isVisible() then return end
		isRepeating = true
		chooser:show()
	end

	return pressedfn, releasedfn, repeatfn
end

function M.launchTimematorOverview()
	local appName = "Timemator"
	local menuItem = { "Window", "Overview" }
	local app = hs.application.find(appName, true)
	local appWasClosed = app == nil

	if app == nil then hs.application.launchOrFocus(appName) end

	hs.timer.waitUntil(function()
		app = hs.application.find(appName, true)
		return app
	end, function()
		assert(app, string.format("Could not find an app named %s", appName))

		local window

		for _, w in ipairs(app:allWindows()) do
			if not w:isStandard() then window = w end
			break
		end

		if window == nil and appWasClosed == false then
			if app:isFrontmost() then
				app:hide() -- hide the app
			else
				app:selectMenuItem(menuItem) -- hide the overview window
			end
		else
			app:selectMenuItem(menuItem) -- show the overview window
		end
	end, 0.2)
end

return M
