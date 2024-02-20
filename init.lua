hs.loadSpoon "SpoonInstall"
local log = require "log"

local mods = { "cmd", "ctrl", "alt" }
local hyper = { "cmd", "ctrl", "alt", "shift" }

-- spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("ReloadConfiguration", {
	hotkeys = {
		reloadConfiguration = { mods, "r" },
	},
	start = true,
})

require "utzwm"

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

local hyper_bindings = {
	{ "1", "1Password" },
	{ "b", "Arc" },
	{ "c", "Calendar" },
	{ "d", "Dash" },
	{ "e", "Mail" },
	{ "f", "Figma" },
	{ "h", "Hammerspoon" },
	{ "l", "Timemator" },
	{ "m", "Messages" },
	{ "n", "Notion" },
	{ "p", "Spotify" },
	{ "s", "Slack" },
	{ "t", "WezTerm" },
	{ "u", "Due" },
	{ "v", "Neovide" },
}

for _, definition in ipairs(hyper_bindings) do
	local key, app = table.unpack(definition)
	local fn = function()
		local curr = hs.application.find(app)
		if curr and curr.isFrontmost and curr:isFrontmost() then
			curr:hide()
			return
		end
		hs.application.launchOrFocus(app)
	end
	if type(app) == "function" then fn = app end
	hs.hotkey.bind(hyper, key, fn)
end

hs.alert.show "Hammerspoon Reloaded!"
