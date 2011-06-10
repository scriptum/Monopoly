field_width = 11 --компаний по горизонтали
field_height = 7 --компаний по вертикали
cell_jail = 13 --на какой клетке тюрьма
--картинки для игроков
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

local rnd_txt = function(a, s)
  if s and a then 
    gui_text.text = a[math.random(1, #a)]:gsub('%%', money(s))
  elseif a then
    gui_text.text = a[math.random(1, #a)]
  end
end
-- общий экшн компаний
__action_company = function(player, f)
	local level = rules_company[player.pos].level
	local money = rules_company[player.pos].money
	local cell = rules_company[player.pos]
	if cell.owner then 
		if cell.owner == player then
			gui_text.text = action_phrase.company_my
		elseif level > 0 then
			f(level, money, cell)
		else
		  gui_text.text = action_phrase.company_mortgage
		end
	else
		gui_text.text = action_phrase.company_free
	end
end

-- Экшн обычных компаний
action_company = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 1 then
	    cash = money[2]
    elseif level == 2 then
	    cash = money[2] * 2
    else
	    cash = money[level]
    end  
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group[cell.group].phrase, cash)
  end)
end

-- Налог
action_nalog = function(player)
  local m = rules_company[player.pos].money
  money_transfer(-m, player)
  rnd_txt(rules_group.nalog.phrase, m)
end

-- Экш нефтяных компаний
action_oil = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 3 then
	    cash = money[2]
    else
	    cash = money[2] * 2 ^ (level - 3)
    end
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group.oil.phrase, cash)
  end)
end

-- Экш банковских компаний
action_bank = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 3 then
	    cash = (ds1 + ds2) * money[2]
    else
	    cash = (ds1 + ds2) * money[3]
    end
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group.bank.phrase, cash)
  end)
end

-- Экшн таможни
action_jail = function(pl)
  pl.pos = 13
  pl.jail = 4
  local x, y = getplayerxy(13, pl.k)
  pl:animate({x=x}, {speed=0.5}):animate({y=y}, {speed=0.5})
  player:delay(1)
  if lquery_fx == true then A.play(sound_jail) end
  rnd_txt(reason_jail)
end

-- Экшн тюрьмы
action_jail_value = function(player)
  if player.jail == 0 and math.random(1, 5) == 1 then 
    action_jail(player)
    rnd_txt(reason_jail_2)
  elseif player.jail == 0 then
    gui_text.text = action_phrase.jail
  end
end

-- Экшн шанса
cashback_chance = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local chance = math.random(1, #rules_chance)
	gui_text.text = rules_chance[chance].text
	rules_chance[chance].action(player, rules_chance[chance])
-- print("Chance: "..rules_chance[chance].money)
end

-- Отъем денег. функция для карточек
cashback = function(player, chance)
  money_transfer(chance.money, player)
end

-- День рождения игрока. функция для карточек
action_birthday = function(pl, card)
  local m = card.money
  for i = 1, __max do
    if player._child[i].ingame == true and player._child[i] ~= pl then
      money_transfer(m, player._child[i], pl)
    end
  end
end

-- Оплата каждой акции. функция для карточек
tax_on_shares = function(pl, card)
  local company
  local number_of_shares = 0
  for i = 1, max do
    company = rules_company[i]
    if company.type == "company" and company.owner == pl and company.group ~= "bank" and company.group ~= "oil" and company.level > 2 then
      number_of_shares = number_of_shares + company.level - 2
    end
  end
  if number_of_shares > 0 then
    money_transfer(-card.money * number_of_shares, pl)
  end
end

-- Экшн казны
cashback_treasury = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local treasury = math.random(1, #rules_treasury)
	gui_text.text = rules_treasury[treasury].text
	rules_treasury[treasury].action(player, rules_treasury[treasury])
-- print("Treasury: "..rules_chance[treasury].money)
end

-- Экшн острова
action_island = function(player)
	gui_text.text = action_phrase.island
end

--предварительная загрузка картинок с игроками в память
rules_player_images = {}
for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, G.newImage('data/gfx/player/'..v))
end

--акции
action = G.newImage('rules/classic/icons/document.dds')
all_actions = G.newImage('rules/classic/icons/briefcase.dds')