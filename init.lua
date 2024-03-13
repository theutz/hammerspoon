hs.loadSpoon "SpoonInstall"

spoon.SpoonInstall:andUse "EmmyLua"
hs.application.enableSpotlightForNameSearches(true)

local reloadr = require "reloadr"
reloadr.setup():start()

local window_manager = require "window_manager"
window_manager.setup()

local hyper = require "hyper"
hyper.setup()

local mouse_keys = require "mouse_keys"
mouse_keys.setup()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
