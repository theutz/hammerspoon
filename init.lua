--- Settings
hs.application.enableSpotlightForNameSearches(true)

require("reloadr").setup():start()

--- Load spoons
hs.loadSpoon "SpoonInstall"

--- Install third-party spoons
spoon.SpoonInstall:andUse "EmmyLua"

--- Initialize my custom spoons
hs.spoons.use("Mousr", { start = true })
hs.spoons.use("Urlr", {
	config = {
		default_browser = "Firefox",
		routes = require "routes",
	},
	start = true,
})

require("windowr").setup()
require("hyperr").setup()
require("appr").setup():start()

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		autoWithdraw = true,
	})
	:send() ---@diagnostic disable-line undefined-field
