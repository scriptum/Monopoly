--перед стартом игры
if F.exists('options.lua') then loadstring('gameoptions = ' .. F.read('options.lua'))() end
if not gameoptions then 
	gameoptions = {
		mode = '800x600',
		fullscreen = false,
		volume = 70
	}
end
local modes = string.split(gameoptions.mode, 'x')
G.setMode(modes[1], modes[2], gameoptions.fullscreen)
A.setVolume(gameoptions.volume/100)