hs.loadSpoon "SpoonInstall"

-- spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	start = true,
	watch_paths = {
		hs.configdir .. "/init.lua",
		hs.configdir .. "/modules",
		hs.configdir .. "/Spoons",
	},
})

local window_manager = require "modules.window_manager"
window_manager.setup()

local hyper = require "modules.hyper"
hyper.setup()

local mouse_keys = require "modules.mouse_keys"
mouse_keys.setup()

hs.application.enableSpotlightForNameSearches(true)

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
