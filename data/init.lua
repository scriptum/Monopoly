require 'data/fonts/font'
require 'data/fonts/tahoma'
require 'data/fonts/ptsmall'
require 'data/fonts/ptbold'
Fonts['Pt Sans Caption'][8]:select()

board_background = G.newImage('data/gfx/background.dds', true)
sep = G.newImage('data/gfx/separator.png')
lock = G.newImage('data/gfx/Lock-icon.png')
fuzzy = G.newImage('data/gfx/fuzzy.png')
player_jail = G.newImage('data/gfx/player/jail.png')

dice = {}
for i = 1,6 do
	dice[i] = G.newImage('data/gfx/dice/'..i..'.png')
end

sound_dice = {}
--~ for i = 1,6 do
	--~ sound_dice[i] = A.newSource('data/sfx/dice' .. i .. '.ogg', 'static')
--~ end
--~ sound_coin = A.newSource('data/sfx/coin.ogg', 'static')
--~ sound_jail = A.newSource('data/sfx/door_close.ogg', 'static')
--~ sound_jail:setVolume(0.2)
--~ sound_out = A.newSource('data/sfx/out.mp3', 'static')
--~ sound_out:setVolume(0.3)
--~ local music = {}
--~ for i = 1,6 do
	--~ table.insert(music, 'data/music/' .. i .. '.ogg')
--~ end
--~ math.randomseed(os.time() + math.random(99999))
--~ table.shuffle(music)
--~ TEsound.playLooping(music, 'music', nil, 0.9)
--~ function love.update()
--~ TEsound.cleanup()
--~ end