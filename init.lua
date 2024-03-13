hs.loadSpoon "SpoonInstall"

spoon.SpoonInstall:andUse "EmmyLua"
hs.application.enableSpotlightForNameSearches(true)

local reloadr = require "modules.reloadr"
reloadr.setup():start()

local window_manager = require "modules.window_manager"
window_manager.setup()

local hyper = require "modules.hyper"
hyper.setup()

local mouse_keys = require "modules.mouse_keys"
mouse_keys.setup()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
