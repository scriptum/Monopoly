-- require 'data/fonts/font'
-- loader(3)
-- require 'data/fonts/liberation'
-- loader(3)

sep = cheetah.newImage('data/gfx/separator.png')
lock = cheetah.newImage('data/gfx/Lock-icon.png')
fuzzy = cheetah.newImage('data/gfx/fuzzy.png')
player_jail = cheetah.newImage('data/gfx/player/jail.png')
-- loader(3)
dice = {}
for i = 1,6 do
	dice[i] = cheetah.newImage('data/gfx/dice/'..i..'.png')
end
-- loader(2)
-- sound_dice = {}
-- for i = 1,6 do
	-- sound_dice[i] = cheetah.newSound('data/sfx/dice' .. i .. '.ogg')
	-- loader(3)
-- end

-- sound_coin = cheetah.newSound('data/sfx/coin.ogg')
-- loader(3)
-- sound_jail = cheetah.newSound('data/sfx/door_close.ogg')
-- sound_jail:setVolume(0.2)
-- loader(3)
-- sound_out = cheetah.newSound('data/sfx/out.ogg')
-- sound_out:setVolume(0.3)
-- loader(3)
-- local music = {}
-- local mus
-- for i = 1,6 do 
	-- _G['mus_'..i] = cheetah.newMusic('data/music/' .. i .. '.ogg')
	-- loader(3)
-- end
-- math.randomseed(os.time() + math.random(99999))

--table.shuffle(music)
--mus_1:play()
--~ mus_m = cheetah.newMusic('data/music/menu.ogg')
--~ mus_m:play()

player_im1 = cheetah.newImage('data/gfx/player/player.png')
player_im2 = cheetah.newImage('data/gfx/player/player2.png')
-- loader(3)
