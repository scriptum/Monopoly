require 'data/fonts/font'
require 'data/fonts/liberation'

sep = S.newImage('data/gfx/separator.png')
lock = S.newImage('data/gfx/Lock-icon.png')
fuzzy = S.newImage('data/gfx/fuzzy.png')
player_jail = S.newImage('data/gfx/player/jail.png')

dice = {}
for i = 1,6 do
	dice[i] = S.newImage('data/gfx/dice/'..i..'.png')
end

sound_dice = {}
for i = 1,6 do
	sound_dice[i] = S.newSound('data/sfx/dice' .. i .. '.ogg')
end
sound_coin = S.newSound('data/sfx/coin.ogg')
sound_jail = S.newSound('data/sfx/door_close.ogg')
sound_jail:setVolume(0.2)
sound_out = S.newSound('data/sfx/out.ogg')
sound_out:setVolume(0.3)
local music = {}
local mus
for i = 1,6 do 
	_G['mus_'..i] = S.newMusic('data/music/' .. i .. '.ogg')
end
math.randomseed(os.time() + math.random(99999))
--table.shuffle(music)
--mus_1:play()
--~ mus_m = S.newMusic('data/music/menu.ogg')
--~ mus_m:play()

player_im1 = S.newImage('data/gfx/player/player.dds')
player_im2 = S.newImage('data/gfx/player/player2.dds')