--- Settings
hs.application.enableSpotlightForNameSearches(true)
hs.logger.defaultLogLevel = "info" -- nothing, error, warning, info, debug, verbose

hs.spoons.use("Reloadr", {
	start = true,
})

--- Load spoons
hs.loadSpoon("SpoonInstall")

--- Install third-party spoons
spoon.SpoonInstall:andUse("EmmyLua")

--- Initialize my custom spoons
hs.spoons.use("Mousr", {
	hotkeys = "default",
	config = {
		speeds = {
			slow = 5,
			normal = 20,
			fast = 100,
		},
	},
})

hs.spoons.use("Urlr", {
	config = {
		default_browser = "Firefox",
		routes = require("routes"),
	},
	start = true,
})

require("windowr").setup()
require("hyperr").setup()
require("appr").setup():start()

spoon.Reloadr:notifyReloaded()
