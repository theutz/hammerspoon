hs.loadSpoon "SpoonInstall"
hs.notify.withdrawAll()

_G.log = hs.logger.new("utz", "info")
_G.info = log.i
_G.dump = function(arg) log.i(hs.inspect(arg)) end

local utzwm = require "utzwm"

-- spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	hotkeys = {
		reloadConfiguration = { utzwm.mods, "r" },
	},
	start = true,
})

spoon.SpoonInstall:andUse("WindowScreenLeftAndRight", {
	hotkeys = {
		screen_left = { utzwm.mods, "[" },
		screen_right = { utzwm.mods, "]" },
	},
})

utzwm.setup()

local hyper = require "hyper"
hyper.setup()

hs.application.enableSpotlightForNameSearches(true)

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
