local hammerspoon = function()
	local app_name = "Hammerspoon"
	local win_name = "Hammerspoon Console"

	local app = hs.application.get("Hammerspoon")
	local win = app:findWindow(win_name)

	local wins = hs.window.orderedWindows()
	local is_focused = win == wins[1] or win == wins[2]

	if is_focused then
		hs.closeConsole()
		hs.window.orderedWindows()[2]:focus()
	else
		local bringToFront = true
		hs.openConsole(bringToFront)

		app = hs.application.get(app_name)
		local console = app:findWindow(win_name)

		if #hs.screen.allScreens() > 1 then
			if console:screen() == hs.screen.primaryScreen() then
				local otherScreen = hs.fnutils.find(
					hs.screen.allScreens(),
					function(screen)
						return screen ~= hs.screen.primaryScreen()
					end
				)
				console:moveToScreen(otherScreen)
			end
			hs.grid.set(console, "7,0 5x12")
		else
			hs.grid.set(console, "8,0 4x12")
		end
	end
end

return hammerspoon
