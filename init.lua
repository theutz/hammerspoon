-- Load IPC module
require("hs.ipc")

-- Add private spoons to package.path
package.path = package.path
	.. ";"
	.. os.getenv("HOME")
	.. "/code/theutz/Spoons/?.spoon/init.lua"
print(package.path)

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

--- Load spoons
hs.loadSpoon("SpoonInstall")

-- hs.window.highlight.start()
-- hs.window.highlight.ui.overlay = true
--
hs.spoons.use("Reloadr", {
	start = true,
	config = require("config.reloadr"),
	-- loglevel = "debug"
})

-- spoon.SpoonInstall:andUse("EmmyLua")

-- hs.spoons.use("Mousr", {
-- 	hotkeys = {
-- 		activate = karabiner.right_command,
-- 	},
-- 	config = require("config.mousr"),
-- 	-- loglevel = "debug"
-- })
--
-- hs.spoons.use("Urlr", {
-- 	config = require("config.urlr"),
-- 	start = true,
-- 	-- loglevel = "debug",
-- })

-- hs.spoons.use("Windowr", {
-- 	hotkeys = "default",
-- 	config = require("config.windowr"),
-- 	start = true,
-- 	-- loglevel = "debug"
-- })
--
-- hs.spoons.use("Frontr", {
-- 	start = true,
-- 	config = require("config.frontr"),
-- 	-- loglevel = "debug"
-- })
--
-- hs.loadSpoon("Deadr")
-- for k, v in pairs(require("config.deadr")) do
-- 	spoon.Deadr[k] = v
-- end
-- spoon.Deadr:bindHotkeys({
-- 	activate = karabiner.right_option,
-- })
-- spoon.Deadr.logger.setLogLevel("debug")

spoon.Reloadr:notifyReloaded()
