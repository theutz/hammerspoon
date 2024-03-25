return {
	max_cols = 5,
	binds = {
		{ "1", "1Password" },
		{
			"b",
			{
				{ "e", "Microsoft Edge" },
				{ "f", "Firefox" },
				{ "g", "Google Chrome" },
				{ "o", "Opera" },
				{ "s", "Safari" },
				{ "v", "Vivaldi" },
			},
			desc = "Browsers",
		},
		{ "c", "Calendar" },
		{ "d", "Dash" },
		{ "e", "Mail" },
		{ "f", "Figma" },
		{
			"g",
			function()
				hs.alert.show("meh")
			end,
			desc = "meh",
		},
		{ "h", "Hammerspoon" },
		{
			"m",
			{
				{ "d", "Discord" },
				{ "e", "Element" },
				{ "f", "Messenger", desc = "Facebook Messenger" },
				{ "m", "Messages" },
				{ "s", "Slack" },
				{ "w", "WhatsApp" },
			},
			desc = "Messaging",
		},
		{ "l", "Timemator" },
		{
			"n",
			{
				{ "a", "Notes", desc = "Apple Notes" },
				{ "n", "Notion" },
			},
			desc = "Notes",
		},
		{ "p", "Spotify" },
		{ "s", "Slack" },
		{ "t", "WezTerm" },
		{ "u", "Due" },
		{ "v", "ClearVPN" },
		{ "w", "Neovide" },
		{ "z", "zoom.us", desc = "Zoom" },
	},
}
