--- Settings
hs.application.enableSpotlightForNameSearches(true)

-- nothing, error, warning, info, debug, verbose
hs.logger.defaultLogLevel = "warning"

hs.spoons.use("Reloadr", {
	start = true,
})

--- Load spoons
hs.loadSpoon("SpoonInstall")

--- Install third-party spoons
-- spoon.SpoonInstall:andUse("EmmyLua")

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

hs.spoons.use("Windowr", {
	hotkeys = "default",
	start = true,
	loglevel = "warning",
})

require("hyperr").setup()

hs.spoons.use("Frontr", {
	start = true,
	config = {
		app_names = {
			"Neovide",
			"WezTerm",
			"wezterm-gui",
			"Spotify",
			"Timemator",
		},
		grid = "1,1 10x10",
	},
})

spoon.Reloadr:notifyReloaded()
