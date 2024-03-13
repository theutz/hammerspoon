hs.loadSpoon "SpoonInstall"

spoon.SpoonInstall:andUse "EmmyLua"
hs.application.enableSpotlightForNameSearches(true)

require("reloadr").setup():start()
require("windowr").setup()
require("hyperr").setup()
require("mouser").setup()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
	})
	:send() ---@diagnostic disable-line undefined-field
