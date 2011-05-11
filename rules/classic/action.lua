field_width = 11 --компаний по горизонтали
field_height = 6 --компаний по вертикали
cell_jail = 13 --на какой клетке тюрьма
--картинки дл€ игроков
rules_player_img = {
	'player_blue.png',
	'player_green.png',
	'player_red.png',
	'player_sea.png',
	'player_yellow.png'
}

rules_player_colors = {
	{0,0,255},
	{0,255,0},
	{255,0,0},
	{0,255,255},
	{255,255,0}
}


local rnd_txt = function(a)
  gui_text.text = a[math.random(1, #a)]
end

-- Ёкшн обычных компаний
action_company = function(player)
	local level = rules_company[player.pos].level
	local money = rules_company[player.pos].money
	local cell = rules_company[player.pos]
	local cash
	if cell.owner then
		if cell.owner ~= player and level > 0 then
			if level == 1 then
				cash = money[2]
			elseif level == 2 then
				cash = money[2] * 2
			else
				cash = money[level]
			end  
			money_transfer(cash, player, cell.owner)
		end
	else
		gui_text.text = action_phrase.company_free
	end
end

-- Ќалог
action_nalog = function(player)
  money_transfer(-rules_company[player.pos].money, player)
  rnd_txt(rules_group.nalog.phrase)
end

-- Ёкш нефт€ных компаний
action_oil = function(player)
	local level = rules_company[player.pos].level
	local money = rules_company[player.pos].money
	local cell = rules_company[player.pos]
	local cash
	if cell.owner and cell.owner ~= player and level > 0 then
	if level == 3 then
		cash = money[2]
	else
		cash = money[2] * 2 ^ (level - 3)
	end
	money_transfer(cash, player, cell.owner)
	rnd_txt(rules_group.oil.phrase)
	end
end

-- Ёкш банковских компаний
action_bank = function(player)
	local level = rules_company[player.pos].level
	local money = rules_company[player.pos].money
	local cell = rules_company[player.pos]
	local cash
	if cell.owner and cell.owner ~= player and level > 0 then
		if level == 3 then
			cash = (ds1 + ds2) * money[2]
		else
			cash = (ds1 + ds2) * money[3]
		end
		money_transfer(cash, player, cell.owner)
		rnd_txt(rules_group.bank.phrase)
	end
end

-- Ёкшн таможни
action_jail = function(pl)
  pl.pos = 13
  pl.jail = 4
  local x, y = getplayerxy(13, pl.k)
  pl:animate({x=x}, {speed=0.5}):animate({y=y}, {speed=0.5})
  player:delay(1)
  if lquery_fx == true then A.play(sound_jail) end
  rnd_txt(reason_jail)
end

-- Ёкшн тюрьмы
action_jail_value = function(player)
  if player.jail == 0 and math.random(1, 5) == 1 then 
    action_jail(player)
    rnd_txt(reason_jail_2)
  elseif player.jail == 0 then
    gui_text.text = action_phrase.jail
  end
end

-- Ёкшн шанса
cashback_chance = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local chance = math.random(1, #rules_chance)
	gui_text.text = 'Ўанс: ' .. rules_chance[chance].text
	money_transfer(rules_chance[chance].money, player)
-- print("Chance: "..rules_chance[chance].money)
end

-- Ёкшн казны
cashback_treasury = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local treasury = math.random(1, #rules_treasury)
	gui_text.text = ' азна: ' .. rules_treasury[treasury].text
	money_transfer(rules_treasury[treasury].money, player)
-- print("Treasury: "..rules_chance[treasury].money)
end

-- Ёкшн острова
action_island = function(player)
	gui_text.text = action_phrase.island
end

--предварительна€ загрузка картинок с игроками в пам€ть
rules_player_images = {}
for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, G.newImage('data/gfx/player/'..v))
end

--акции
action = G.newImage('rules/classic/icons/document.png')
all_actions = G.newImage('rules/classic/icons/briefcase.png')