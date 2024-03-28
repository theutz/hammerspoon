local obj = {}

local some = hs.fnutils.some
local partial = hs.fnutils.partial

obj.name = "Urlr"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael@theutz.com>"
obj.license = "MIT"
obj.homepage = "https://theutz.com"

obj.default_browser = "Firefox"

obj.routes = {}

function obj:init()
	return self
end

function obj:start()
	hs.urlevent.httpCallback = obj:http_callback()
	return self
end

function obj:open_url_in_browser(url, browser)
	hs.task
		.new(
			"/usr/bin/open",
			function() end,
			{ "-a", browser or self.default_browser, url }
		)
		:start()
end

function obj:http_callback()
	return function(_, host, _, fullURL)
		local go = partial(self.open_url_in_browser, self, fullURL) --[[@as function]]
		for browser, hosts in pairs(obj.routes) do
			if some(hosts, self.matchHost(host)) then
				go(browser)
				return
			end
		end
		hs.chooser
			.new(function(browser)
				go(browser and browser.text)
			end)
			:choices(function()
				local choices = {}
				for k, _ in pairs(obj.routes) do
					table.insert(choices, { text = k })
				end
				return choices
			end)
			:show()
	end
end

function obj.matchHost(host)
	return function(pattern)
		return string.match(host, pattern)
	end
end

return obj
