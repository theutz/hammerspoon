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

hyper.bindApp({}, "a", "RapidAPI")
hyper.bindApp({}, "c", "Google Chrome")
hyper.bindApp({}, "d", "Dash")
hyper.bindApp({}, "f", "Figma")
hyper.bindApp({}, "h", "HELO")
hyper.bindApp({}, "l", "Loom")
hyper.bindApp({}, "k", "kitty")
hyper.bindApp({}, "n", "Tinkerwell")
hyper.bindApp({}, "r", "Ray")
hyper.bindApp({}, "t", "TablePlus")

local function toggleApp(appName)
	return function()
		if app.find(appName) then
			local curr = app.find(appName)
			if curr and curr:isFrontmost() then
				curr:hide()
				return
			end
		end

		app.launchOrFocus(appName)
	end
end

hk.bindSpec({ {}, "f1" }, toggleApp("1Password"))
hk.bindSpec({ {}, "f2" }, toggleApp("Arc"))
hk.bindSpec({ {}, "f3" }, toggleApp("Canary Mail"))
hk.bindSpec({ {}, "f4" }, toggleApp("Google Chrome"))
hk.bindSpec({ {}, "f5" }, toggleApp("Loom"))
hk.bindSpec({ {}, "f6" }, toggleApp("zoom.us"))
hk.bindSpec({ {}, "f7" }, toggleApp(""))
hk.bindSpec({ {}, "f8" }, toggleApp("Spotify"))
hk.bindSpec({ {}, "f9" }, toggleApp("Telegram"))
hk.bindSpec({ {}, "f10" }, toggleApp("WhatsApp"))
hk.bindSpec({ {}, "f11" }, toggleApp("Messages"))
hk.bindSpec({ {}, "f12" }, toggleApp("Slack"))

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

hk.bindSpec({ mods, "c" }, runInShell("doom +everywhere"))
hk.bindSpec({ mods, "x" }, runInShell("emacsclient -ne '(utz/make-capture-frame)'"))

hs.alert.show("Hammerspoon Reloaded!")
