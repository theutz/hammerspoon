local partial = hs.fnutils.partial

---@class Deadr
local obj = {}

---@public
obj.name = "Deadr"

---@public
obj.author = "Michael Utz <michael@theutz.com>"

---@public
obj.version = "0.0.0"

---@public
obj.license = "MIT"

---@public
obj.homepage = "https://theutz.com"

---@public
obj.binds = {}

---@private
obj.logger = hs.logger.new(obj.name)

---@private
obj.defaultHotkeys = {
	toggle = { {}, "f19" },
}

---@private { modal: hs.hotkey.modal, hud: Hud }[]
obj.layers = {}

function obj:init()
	return self
end

---@public
---@return self
function obj:bindHotkeys(map)
	local def = {
		toggle = hs.fnutils.partial(self.toggle, self),
	}

	hs.spoons.bindHotkeysToSpec(def, map)
	--
	-- self.modal:bind(
	-- 	map.toggle[1],
	-- 	map.toggle[2],
	-- 	hs.fnutils.partial(self.toggle, self)
	-- )
	-- self.modal:bind({ "" }, "escape", hs.fnutils.partial(self.exit, self))
	--
	return self
end

-- function obj:activate(defs)
-- local items = {}
-- for _, item in ipairs(defs) do
-- 	local key, app, desc = table.unpack(item)
-- 	table.insert(items, { key, desc or app })
-- 	if type(app) == "table" then
-- 	-- TODO: Work with a stack of modals/huds
-- 	elseif type(app) == "string" then
-- 		self.modal:bind("", key, self.appOpener(app))
-- 	end
-- end
-- self.hud:setItems(items)
-- self.modal:enter()
-- end

function obj.appOpener(hint)
	if type(hint) == "function" then
		return hint
	end
	return function()
		local exact = true
		local app = hs.application.find(hint, exact)
		if app then
			if app:isFrontmost() then
				app:hide()
			else
				local allWindows = true
				app:setFrontmost(allWindows)
			end
		else
			hs.application.open(hint)
		end
	end
end

function obj:toggle()
	if #self.layers == 0 then
		table.insert(self.layers, self:makeLayer(self.binds))
		self.layers[1].modal:enter()
	else
		for _, layer in ipairs(self.layers) do
			layer.modal:exit()
		end
		self.layers = {}
	end
end

function obj:makeLayer(defs)
	local modal = hs.hotkey.modal.new()
	local hud = dofile(hs.spoons.resourcePath("hud.lua")):new({
		logger = self.logger,
	}) --[[@as Hud]]

	local items = {}

	for _, def in ipairs(defs) do
		local mods = { "" }
		local key, nameOrSubDef = table.unpack(def)
		if type(nameOrSubDef) == "string" then
			local name = nameOrSubDef
			table.insert(items, { key, def.desc or name })
			modal:bind(mods, key, self.appOpener(name))
		elseif type(nameOrSubDef) == "table" then
			local subDef = nameOrSubDef
			assert(def.desc, "Sub-items must have an explicit description")
			table.insert(items, { key, def.desc })
			modal:bind(mods, key, function()
				for _, layer in self.layers do
					layer.modal:exit()
				end
				table.insert(self.layers, self:makeLayer(subDef))
				self.layers[#self.layers]:enter()
			end)
		end
	end

	hud:setItems(items)

	---@diagnostic disable-next-line: duplicate-set-field
	function modal.entered()
		hud:show()
	end

	---@diagnostic disable-next-line: duplicate-set-field
	function modal:exited()
		hud:hide()
	end

	return { modal = modal, hud = hud }
end

return obj
