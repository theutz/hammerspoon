-- Karabiner
local karabiner = {
	right_command = { {}, "f18" },
	right_option = { {}, "f19" },
	escape = { {}, "f20" },
}

-- Settings
hs.application.enableSpotlightForNameSearches(true)

-- nothing, error, warning, info, debug, verbose
hs.logger.defaultLogLevel = "warning"

hs.spoons.use("Reloadr", {
	start = true,
	config = require("config.reloadr"),
})

--- Load spoons
hs.loadSpoon("SpoonInstall")

--- Install third-party spoons
-- spoon.SpoonInstall:andUse("EmmyLua")

hs.spoons.use("Mousr", {
	hotkeys = {
		activate = karabiner.right_option,
	},
	config = require("config.mousr"),
})

hs.spoons.use("Urlr", {
	config = require("config.urlr"),
	start = true,
})

hs.spoons.use("Windowr", {
	hotkeys = "default",
	config = require("config.windowr"),
	start = true,
})

hs.spoons.use("Frontr", {
	start = true,
	config = require("config.frontr"),
})

hs.spoons.use("Deadr", {
	hotkeys = {
		activate = karabiner.escape,
	},
	config = require("config.deadr"),
	loglevel = "debug",
})

spoon.Reloadr:notifyReloaded()
