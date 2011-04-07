board_background = G.newImage('data/gfx/wood-046_afara-white-1_d.jpg')
sep = G.newImage('data/gfx/separator.png')
logo = G.newImage('data/gfx/logos/mcdonalds-logo.png')
fuzzy = G.newImage('data/gfx/fuzzy.png')
dice = {}
for i = 1,6 do
	dice[i] = G.newImage('data/gfx/dice/'..i..'.png')
end