local M = {}

M.hyper_keys = { "cmd", "ctrl", "alt", "shift" }

function M.setup()
	for _, definition in ipairs(require "hyperr.bindings") do
		local key, apps, releasedfn, repeatfn = table.unpack(definition)
		local keySpec = { M.hyper_keys, key }
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

return M
