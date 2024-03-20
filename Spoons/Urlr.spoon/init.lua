---@alias UrlrRoutes { [string]: string[] }

---@class (exact) Urlr
---@field name string
---@field version string
---@field author string
---@field license string
---@field homepage string
---@field init function fun(self: self): self
---@field start fun(self: self): self
---@field setDefaultBrowser fun(self, browser: string): self
---@field setRoutes fun(self, routes): self
---@field http_callback fun(self): fun(scheme: string, host: string, params: {[string]: string}[], fullURL: string): nil
---@field open_url_in_browser fun(url, browser): nil
---@field default_browser? string
---@field routes UrlrRoutes?
local obj = {}

---@public
obj.name = "Urlr"

---@public
obj.version = "0.0.0"

---@public
obj.author = "Michael Utz <michael@theutz.com>"

---@public
obj.license = "MIT"

---@public
obj.homepage = "https://theutz.com"

---@public
obj.default_browser = "Firefox"

---@public
obj.routes = {}

---@public
---@nodiscard
function obj:init() return self end

---@public
---@nodiscard
function obj:start()
	hs.urlevent.httpCallback = obj:http_callback()
	return self
end

---@public
---@nodiscard
function obj:setDefaultBrowser(browser)
	obj.default_browser = browser
	return self
end

---@public
---@nodiscard
function obj:setRoutes(routes)
	obj.routes = routes
	return self
end

---@private
---@nodiscard
function obj.open_url_in_browser(url, browser)
	hs.task.new("/usr/bin/open", function() end, { "-a", browser, url }):start()
end

---@private
---@nodiscard
function obj:http_callback()
	return function(_, host, _, fullURL)
		for browser, patterns in pairs(obj.routes) do
			if hs.fnutils.some(patterns, function(pattern) return string.match(host, pattern) end) then
				self.open_url_in_browser(fullURL, browser)
				return
			end
		end
		self.open_url_in_browser(fullURL, self.default_browser)
	end
end

return obj
