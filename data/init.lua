board_background = G.newImage('data/gfx/background.jpg')
sep = G.newImage('data/gfx/separator.png')
lock = G.newImage('data/gfx/Lock-icon.png')
fuzzy = G.newImage('data/gfx/fuzzy.png')
player_jail = G.newImage('data/gfx/player/jail.png')

dice = {}
for i = 1,6 do
	dice[i] = G.newImage('data/gfx/dice/'..i..'.png')
end
action = G.newImage('data/gfx/blue_icons/document.png')
all_actions = G.newImage('data/gfx/blue_icons/briefcase.png')

sound_dice = {}
for i = 1,6 do
	sound_dice[i] = A.newSource('data/sfx/dice' .. i .. '.ogg', 'static')
end
sound_coin = A.newSource('data/sfx/coin.ogg', 'static')
sound_jail = A.newSource('data/sfx/door_close.ogg', 'static')
sound_jail:setVolume(0.5)
local music = {}
for i = 1,7 do
	table.insert(music, 'data/music/' .. i .. '.ogg')
end
TEsound.playLooping(music, 'music', 0, 0.9)