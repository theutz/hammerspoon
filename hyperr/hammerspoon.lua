return function()
	local win = hs.window.focusedWindow()
	local app = win:application()
	local name = "Hammerspoon"
	if app and app:name() == name then
		app:hide()
		hs.notify.withdrawAll()
		hs.console.clearConsole()
	else
		hs.openConsole(true)
		app = hs.application.get(name)
		local console = app:findWindow "Hammerspoon Console"
		if #hs.screen.allScreens() > 1 then
			if console:screen() == hs.screen.primaryScreen() then
				local otherScreen = hs.fnutils.find(
					hs.screen.allScreens(),
					function(screen) return screen ~= hs.screen.primaryScreen() end
				)
				console:moveToScreen(otherScreen)
			end
			hs.grid.set(console, "7,0 5x12")
		else
			hs.grid.set(console, "8,0 4x12")
		end
	end
end
