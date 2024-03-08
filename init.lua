hs.loadSpoon "SpoonInstall"
hs.notify.withdrawAll()

_G.log = hs.logger.new("utz", "info")
_G.info = log.i
_G.dump = function(arg) log.i(hs.inspect(arg)) end

local mods = { "cmd", "ctrl", "alt" }

-- spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	hotkeys = {
		reloadConfiguration = { mods, "r" },
	},
	start = true,
})

spoon.SpoonInstall:andUse("WindowScreenLeftAndRight", {
	hotkeys = {
		screen_left = { mods, "[" },
		screen_right = { mods, "]" },
	},
})

local utzwm = require "utzwm"
utzwm.setup(mods)

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
