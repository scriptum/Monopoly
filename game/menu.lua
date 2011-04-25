gamemenu = E:new(screen)
local modes = G.getModes()
table.sort(modes, function(a, b) return a.width < b.width end)
local dislay_modes = {}
for _, v in pairs(modes) do
	table.insert(dislay_modes, v.width .. 'x' .. v.height)
end
current_mode = '800x600'
current_fullscreen = false
local screenlist = E:new(gamemenu):move(200, 300):list('Screen resolution', dislay_modes, dislay_modes, {'current_mode'})

require('ui.button')
E:new(gamemenu):move(200, 400):button('Apply', function(s) 
	local p = screenlist._pos
	G.setMode(modes[p].width, modes[p].height, current_fullscreen)
	screen_scale, x_screen_scale, y_screen_scale = getScale() --rescale screen
end)