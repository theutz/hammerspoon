--- Settings
hs.application.enableSpotlightForNameSearches(true)

-- nothing, error, warning, info, debug, verbose
hs.logger.defaultLogLevel = "warning"

hs.spoons.use("Reloadr", {
	start = true,
	config = {
		clearConsole = true,
	},
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

-- require("hyperr").setup()

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

hs.spoons.use("Deadr", {
	hotkeys = "default",
	config = {
		binds = {
			{ "1", "1Password" },
			{
				"b",
				{ { "f", "Firefox" }, { "g", "Google Chrome" } },
				desc = "Browsers",
			},
			{ "c", "Calendar" },
			{ "d", "Dash" },
			{ "e", "Mail" },
			{ "f", "Figma" },
			{ "h", "Hammerspoon" },
			{ "m", "Messages" },
			{ "l", "Timemator" },
			{ "n", "Notion" },
			{ "p", "Spotify" },
			{ "s", "Slack" },
			{ "t", "WezTerm" },
			{ "u", "Due" },
			{ "v", "ClearVPN" },
			{ "w", "Neovide" },
			{ "z", "zoom.us", desc = "Zoom" },
		},
	},
	loglevel = "debug",
})

spoon.Reloadr:notifyReloaded()
