return {
	default_browser = "Firefox",
	---@type { [string]: string[] }
	routes = {
		["Firefox"] = {
			"notion.so",
			"reddit.com",
			"reddit%a*.com",
			"facebook.com",
			"instagram.com",
			"threads.net",
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
		},
	},
}
