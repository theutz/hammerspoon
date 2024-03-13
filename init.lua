hs.loadSpoon "SpoonInstall"

spoon.SpoonInstall:andUse "EmmyLua"
hs.application.enableSpotlightForNameSearches(true)

local reloadr = require "reloadr"
reloadr.setup():start()

local windowr = require "windowr"
windowr.setup()

local hyperr = require "hyperr"
hyperr.setup()

local mouser = require "mouser"
mouser.setup()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
