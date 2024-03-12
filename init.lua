hs.loadSpoon "SpoonInstall"
hs.notify.withdrawAll()

_G.log = hs.logger.new("utz", "info")
_G.dump = function(...) print(hs.inspect(...)) end

-- spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	start = true,
})

local window_manager = require "window_manager"
window_manager.setup()

local hyper = require "hyper"
hyper.setup()

local mouse_keys = require "mouse_keys"
mouse_keys.setup()

hs.application.enableSpotlightForNameSearches(true)

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config reloaded!",
		withdrawAfter = 1,
	})
	:send()
