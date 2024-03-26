local function fromSettings(setting)
	return function(toggler)
		local def = hs.settings.get(setting)
		if def == nil then
			local message = setting
			local informativeText = "What should the default value be?"
			local defaultValue = ""
			local button1 = "Save"
			local button2 = "Cancel"
			local button, value = hs.dialog.textPrompt(
				message,
				informativeText,
				defaultValue,
				button1,
				button2
			)
			if button == button1 then
				hs.settings.set(setting, value)
				def = value
			end
		end
		toggler(def)
	end
end

local browsers = {
	{
		"b",
		fromSettings("default_browser"),
		desc = "Default",
	},
	{ "e", "Microsoft Edge" },
	{ "f", "Firefox" },
	{ "g", "Google Chrome" },
	{ "o", "Opera" },
	{ "s", "Safari" },
	{ "v", "Vivaldi" },
	{ "r", "io.raindrop.macapp", desc = "Raindrop" },
}

local messages = {
	{ "a", "Messages", desc = "Apple Messages" },
	{ "d", "Discord" },
	{ "e", "Mail", desc = "Email" },
	{ "f", "Messenger", desc = "Facebook Messenger" },
	{ "i", "Ivory" },
	{ "m", fromSettings("default_messages"), desc = "Default" },
	{ "s", "Slack" },
	{ "w", "WhatsApp" },
	{ "x", "Element" },
	{ "t", "Telegram" },
}

local terminals = {
	{ "w", "WezTerm" },
	{ "t", fromSettings("default_terminal"), desc = "Default" },
	{ "i", "iTerm 2" },
	{ "a", "Terminal", desc = "Apple Terminal" },
}

local notes = {
	{ "n", fromSettings("default_notes"), desc = "Default" },
	{ "a", "Notes", desc = "Apple Notes" },
	{ "o", "Notion" },
}

local vpns = {
	{ "v", fromSettings("default_vpn"), desc = "Default" },
	{ "c", "ClearVPN" },
	{ "n", "NordVPN" },
	{ "s", "Surfshark" },
}

local reminders = {
	{ "a", "Reminders", desc = "Apple Reminders" },
	{ "r", fromSettings("default_reminders"), desc = "Default" },
	{ "d", "Due" },
	{ "g", "Godspeed" },
	{
		"c",
		function()
			hs.urlevent.openURL(
				"raycast://extensions/raycast/apple-reminders/my-reminders"
			)
		end,
		desc = "Raycast Agenda",
	},
}

local music = {
	{ "s", "Spotify" },
	{ "p", fromSettings("default_music"), desc = "Default" },
	{ "m", "Music", desc = "Apple Music" },
}

return {
	cell = {
		width = 140,
		height = 120,
	},
	table = {
		cols = 5,
	},
	binds = {
		{ "1", "1Password" },
		{ "b", browsers, desc = "Browsers" },
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Neovide" },
		{ "f", "Figma" },
		{ "h", require("config.deadr.hammerspoon"), desc = "Hammerspoon" },
		{ "m", messages, desc = "Messaging" },
		{ "l", "Timemator" },
		{ "n", notes, desc = "Notes" },
		{ "p", music, desc = "Music" },
		{ "r", reminders, desc = "Reminders" },
		{ "s", require("config.deadr.splits"), desc = "Splits" },
		{ "t", terminals, desc = "Terminals" },
		{ "v", vpns, desc = "VPNs" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
