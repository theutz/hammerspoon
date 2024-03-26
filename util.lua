local M = {}

function M.axHotfix(win)
	if not win then
		win = hs.window.frontmostWindow()
	end

	local axApp = hs.axuielement.applicationElement(win:application()) or {}
	local wasEnhanced = axApp.AXEnhancedUserInterface
	if wasEnhanced then
		axApp.AXEnhancedUserInterface = false
	end

	return function()
		if wasEnhanced then
			axApp.AXEnhancedUserInterface = true
		end
	end
end

function M.withAxHotfix(fn, position)
	if not position then
		position = 1
	end
	return function(...)
		local args = { ... }
		local revert = M.axHotfix(args[position])
		fn(...)
		revert()
	end
end

return M
