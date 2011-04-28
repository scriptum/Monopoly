gameoptions = {
	mode = '800x600',
	fullscreen = false
}

gamemenu = E:new(screen):hide()
menuvsettings = E:new(gamemenu):hide()
local modes = G.getModes()
table.sort(modes, function(a, b) return a.width < b.width end)
local dislay_modes = {}
for _, v in pairs(modes) do
	table.insert(dislay_modes, v.width .. 'x' .. v.height)
end

local screenlist = E:new(menuvsettings):move(200, 150):list('Screen resolution', dislay_modes, dislay_modes, {'gameoptions', 'mode'})
local screenmode = E:new(menuvsettings):move(200, 200):list('Screen mode', {true, false}, {'fullscreen', 'windowed'}, {'gameoptions', 'fullscreen'})
require('ui.button')
E:new(menuvsettings):move(130, 400):button('Apply', function(s) 
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

local function mainsettings() menumain:menutoggle(menuvsettings) end
E:new(menuvsettings):move(414, 400):button('Back', mainsettings)

menumain = E:new(gamemenu):menu({
	{text = 'Singleplayer', action = nil},
	{text = 'Multiplayer', action = nil},
	{text = 'Audio settings', action = nil},
	{text = 'Video settings', action = mainsettings},
	{text = 'Quit', action = function() love.event.push('q') end}
})