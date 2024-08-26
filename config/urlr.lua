return {
	default_browser = "qutebrowser",
	use_chooser = false,
	---@type { [string]: string[] }
	routes = {
		["qutebrowser"] = {
			"notion.so",
			"reddit.com",
			"reddit%a*.com",
			"threads.net",
			"linkedin.com",
			"x.com",
			"twitter.com",
			"hachyderm.io",
			"bsky.app",
		},
		["Firefox"] = {
			"facebook.com",
			"instagram.com",
		},
		["Google Chrome"] = {
			"bugherd.com",
			"google.com",
			"hubspot.com",
			"zoho.com",
			"slack.com",
			"standupbot.com",
		},
		["chooser"] = {
			"github.com",
		},
	},
}
