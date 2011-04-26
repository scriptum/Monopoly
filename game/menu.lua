gameoptions = {
	mode = '800x600',
	fullscreen = false
}

gamemenu = E:new(screen):hide()
mainmenu = E:new(gamemenu)
local modes = G.getModes()
table.sort(modes, function(a, b) return a.width < b.width end)
local dislay_modes = {}
for _, v in pairs(modes) do
	table.insert(dislay_modes, v.width .. 'x' .. v.height)
end

local screenlist = E:new(mainmenu):move(200, 150):list('Screen resolution', dislay_modes, dislay_modes, {'gameoptions', 'mode'})
local screenmode = E:new(mainmenu):move(200, 200):list('Screen mode', {true, false}, {'fullscreen', 'windowed'}, {'gameoptions', 'fullscreen'})
require('ui.button')
E:new(gamemenu):move(200, 400):button('Apply', function(s) 
	local p = screenlist._pos
	local mode = screenlist._vars[p]
	local full = screenmode._vars[screenmode._pos]
	if gameoptions.mode ~= mode or gameoptions.fullscreen ~= full then
		gameoptions.mode = mode
		gameoptions.fullscreen = full
		G.setMode(modes[p].width, modes[p].height, full)
		screen_scale, x_screen_scale, y_screen_scale = getScale() --rescale screen
	end
end)