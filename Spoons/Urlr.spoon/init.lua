---@alias UrlrRoutes { [string]: string[] }

---@class (exact) Urlr
---@field public name string
---@field public version string
---@field public author string
---@field public license string
---@field public homepage string
---@field public init function fun(s: self): self
---@field public start fun(s: self): self
---@field public setDefaultBrowser fun(s: self, browser: string): self
---@field public setRoutes fun(s: self, routes: UrlrRoutes): self
---@field private http_callback fun(self): fun(scheme: string, host: string, params: {[string]: string}[], fullURL: string): nil
---@field private open_url_in_browser fun(url, browser): nil
---@field private default_browser string
---@field private routes UrlrRoutes
local obj = {}

obj.name = "Urlr"
obj.version = "0.0.0"
obj.author = "Michael Utz <michael@theutz.com>"
obj.license = "MIT"
obj.homepage = "https://theutz.com"

obj.default_browser = "Firefox"

obj.routes = {}

---@nodiscard
function obj:init() return self end

---@nodiscard
function obj:start()
	hs.urlevent.httpCallback = obj:http_callback()
	return self
end

---@nodiscard
function obj:setDefaultBrowser(browser)
	obj.default_browser = browser
	return self
end

---@nodiscard
function obj:setRoutes(routes)
	obj.routes = routes
	return self
end

---@nodiscard
function obj.open_url_in_browser(url, browser)
	hs.task.new("/usr/bin/open", function() end, { "-a", browser, url }):start()
end

---@nodiscard
function obj:http_callback()
	return function(_, host, _, fullURL)
		for browser, patterns in pairs(obj.routes) do
			if
				hs.fnutils.some(
					patterns,
					function(pattern) return string.match(host, pattern) end
				)
			then
				self.open_url_in_browser(fullURL, browser)
				return
			end
		end
		self.open_url_in_browser(fullURL, self.default_browser)
	end
end

return obj
