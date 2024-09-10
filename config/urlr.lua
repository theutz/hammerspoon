return {
	default_browser = "qutebrowser",
	use_chooser = false,
	---@type { [string]: string[] }
	routes = {
		["Firefox"] = {
			"facebook.com",
			"instagram.com",
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
