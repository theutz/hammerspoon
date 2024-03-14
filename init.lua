hs.loadSpoon "SpoonInstall"

-- spoon.SpoonInstall:andUse "EmmyLua"
hs.application.enableSpotlightForNameSearches(true)

require("urlr").setup()
require("reloadr").setup():start()
require("windowr").setup()
require("hyperr").setup()
require("mouser").setup()
require("appr").setup():start()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		autoWithdraw = true,
	})
	:send() ---@diagnostic disable-line undefined-field
