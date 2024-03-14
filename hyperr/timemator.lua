return function()
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
