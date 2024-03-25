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
	config = require("config.urlr"),
	start = true,
})

hs.spoons.use("Windowr", {
	hotkeys = "default",
	start = true,
	loglevel = "warning",
})

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
		max_cols = 5,
		binds = {
			{ "1", "1Password" },
			{
				"b",
				{
					{ "e", "Microsoft Edge" },
					{ "f", "Firefox" },
					{ "g", "Google Chrome" },
					{ "o", "Opera" },
					{ "s", "Safari" },
					{ "v", "Vivaldi" },
				},
				desc = "Browsers",
			},
			{ "c", "Calendar" },
			{ "d", "Dash" },
			{ "e", "Mail" },
			{ "f", "Figma" },
			{ "h", "Hammerspoon" },
			{
				"m",
				{
					{ "d", "Discord" },
					{ "e", "Element" },
					{ "f", "Messenger", desc = "Facebook Messenger" },
					{ "m", "Messages" },
					{ "s", "Slack" },
					{ "w", "WhatsApp" },
				},
				desc = "Messaging",
			},
			{ "l", "Timemator" },
			{
				"n",
				{
					{ "a", "Notes", desc = "Apple Notes" },
					{ "n", "Notion" },
				},
				desc = "Notes",
			},
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
