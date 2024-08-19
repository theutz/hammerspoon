local obj = {}

local some = hs.fnutils.some
local partial = hs.fnutils.partial

obj.name = "Urlr"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael@theutz.com>"
obj.license = "MIT"
obj.homepage = "https://theutz.com"

obj.logger = hs.logger.new("urlr")

obj.default_browser = "Firefox"

obj.use_chooser = true

obj.routes = {}

function obj:init()
	return self
end

function obj:start()
	hs.urlevent.httpCallback = obj:http_callback()
	return self
end

function obj:open_url_in_browser(url, browser)
	local oldWin = hs.window.orderedWindows()[2]
	self.logger.df(
		---@diagnostic disable-next-line: param-type-mismatch
		"current focused window: %s",
		---@diagnostic disable-next-line: undefined-field
		oldWin:application():name()
	)

	hs.task
		.new("/usr/bin/open", function()
			local newWin = hs.window.frontmostWindow()
			self.logger.df(
				---@diagnostic disable-next-line: param-type-mismatch
				"window focus after urlr: %s",
				---@diagnostic disable-next-line: undefined-field
				newWin:application():name()
			)
			oldWin:focus()
			newWin:focus()
		end, { "-a", browser or self.default_browser, url })
		:start()
end

function obj:http_callback()
	return function(_, host, _, fullURL)
		local go = partial(self.open_url_in_browser, self, fullURL) --[[@as function]]
		local use_chooser = self.use_chooser

		for browser, hosts in pairs(obj.routes) do
			if some(hosts, self.matchHost(host)) then
				if string.match(browser, "chooser") then
					use_chooser = true
					break
				end
				go(browser)
				return
			end
		end

		if use_chooser == true then
			hs.chooser
				.new(function(browser)
					go(browser and browser.text)
				end)
				:choices(function()
					local choices = {}
					for k, _ in pairs(obj.routes) do
						if not string.match(k, "chooser") then
							table.insert(choices, { text = k })
						end
					end
					return choices
				end)
				:show()
		else
			go()
		end
	end
end

function obj.matchHost(host)
	return function(pattern)
		return string.match(host, pattern)
	end
end

return obj
