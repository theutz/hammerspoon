--- Settings
hs.application.enableSpotlightForNameSearches(true)

--- Load spoons
hs.loadSpoon "SpoonInstall"

--- Install third-party spoons
-- spoon.SpoonInstall:andUse "EmmyLua"

--- Initialize my custom spoons
hs.loadSpoon "Mousr"
spoon.Mousr:bindHotKeys {}
spoon.Mousr:start()

require("urlr").setup()
require("reloadr").setup():start()
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
