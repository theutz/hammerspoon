hs.loadSpoon("SpoonInstall")
local app = hs.application
local hk = hs.hotkey
local log = require("log")

local mods = { "cmd", "ctrl", "alt" }

--spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	hotkeys = {
		reloadConfiguration = { mods, "r" },
	},
	start = true,
})

local hyper = require("hyper")
require("utzwm")

local function logTaskErr(taskName)
	return function(exitCode, stdOut, stdErr)
		log.f("Running %s", taskName)
		log.d(stdOut)

		if exitCode > 0 then
			log.ef("%s: %d %s", taskName, exitCode, stdErr)
		end
	end
end

local function runInShell(command)
	return function()
		hs.task.new("/opt/homebrew/bin/fish", logTaskErr(command), { "-l", "-c", command }):start()
	end
end

hs.alert.show("Hammerspoon Reloaded!")
