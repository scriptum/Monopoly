--предварительная загрузка картинок с игроками в память
rules_player_images = {}
--картинки для игроков
local rules_player_img = {
	'blue_smiley.png',
	'mike.png',
	'boss.png',
	'hell_boy.png',
	'grimace.png',
}

rules_player_colors = {
	{0,0,255},
	{0,255,0},
	{255,255,0},
	{255,0,0},
	{0,0,0},
}

for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, cheetah.newImage('data/gfx/player/'..v))
end

--предварительная загрузка картинок с группами в память
rules_group_images = {}
for k, v in pairs(rules_group) do 
	if v.image then
		rules_group_images[k] = cheetah.newImage('rules/classic/icons/'..v.image)
	end
end

--предварительная загрузка картинок с компаниями в память
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
	table.insert(rules_company_images, cheetah.newImage('rules/classic/'..lang..'/logos/'..k..'.png'))
end

--акции
action = cheetah.newImage('rules/classic/icons/document.png')
all_actions = cheetah.newImage('rules/classic/icons/briefcase.png')
