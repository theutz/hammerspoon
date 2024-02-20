hs.loadSpoon "SpoonInstall"
local log = require "log"

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

local function logTaskErr(taskName)
	return function(exitCode, stdOut, stdErr)
		log.f("Running %s", taskName)
		log.d(stdOut)

		if exitCode > 0 then log.ef("%s: %d %s", taskName, exitCode, stdErr) end
	end
end

local function runInShell(command)
	return function() hs.task.new("/opt/homebrew/bin/zsh", logTaskErr(command), { "-l", "-c", command }):start() end
end

hs.application.enableSpotlightForNameSearches(true)

hs.alert.show "Hammerspoon Reloaded!"
