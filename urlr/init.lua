local M = {}

local routes = {
	["Google Chrome"] = {
		"bugherd.com",
	},
	["Firefox"] = {
		"reddit.com",
		"facebook.com",
	},
}

local default_browser = "Firefox"

function M.setup() hs.urlevent.httpCallback = M.http_callback end

function M.http_callback(scheme, host, params, fullURL)
	for browser, patterns in pairs(routes) do
		if hs.fnutils.some(patterns, function(pattern) return string.match(host, pattern) end) then
			M.open_url_in_browser(fullURL, browser)
			return
		end
	end
	M.open_url_in_browser(fullURL, default_browser)
end

function M.open_url_in_browser(url, browser)
	hs.task.new("/usr/bin/open", function() end, { "-a", browser, url }):start()
end

return M
