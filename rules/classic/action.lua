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
	{50,70,255},
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

local m_tr = function(plk, cash, pos)
  local pl = current_game.players[plk]
  pl.cash = pl.cash - cash
  msg_add('set_cash', plk, pl.cash)
  if pos then
    local plk2 = current_game.companys[pos].owner
    local pl2 = current_game.players[plk2]
    pl2.cash = pl2.cash + cash
    msg_add('set_cash', plk2, pl2.cash)
    --msg_add('cash_trans', plk, plk2)
  end
end

-- общий экшн компаний
local __action = function(plk, f)
  local pos = current_game.players[plk].pos
  local com = current_game.companys[pos]
  local level = com.level
  local money = rules_company[pos].money
  local owner = com.owner
  if owner then 
    if owner == plk then
	    --gui_text.text = action_phrase.company_my
    elseif level > 0 then
	    f(plk, level, money, pos)
    else
      --gui_text.text = action_phrase.company_mortgage
    end
  else
    --gui_text.text = action_phrase.company_free
  end
end

-- Экшн обычных компаний
local _action_company = function(plk, level, money, pos)
  local cash
  if level == 1 then
	  cash = money[2]
  elseif level == 2 then
	  cash = money[2] * 2
  else
	  cash = money[level]
  end
  m_tr(plk, cash, pos)
  --rnd_txt(rules_group[cell.group].phrase, cash)
end
action_company = function(plk)
  __action(plk, _action_company)
end

-- Налог
action_nalog = function(plk)
  local pl = current_game.players[plk]
  local m = rules_company[pl.pos].money
  m_tr(plk, m)
  --rnd_txt(rules_group.nalog.phrase, m)
end

-- Экш нефтяных компаний
local _action_oil = function(plk, level, money, pos)
  local cash
  if level == 3 then
    cash = money[2]
  else
    cash = money[2] * 2 ^ (level - 3)
  end
  m_tr(plk, cash, pos)
  --rnd_txt(rules_group.oil.phrase, cash)
end
action_oil = function(plk)
  __action(plk, _action_oil)
end

-- Экш банковских компаний
local _action_bank = function(plk, level, money, pos)
  local cash
  if level == 3 then
    cash = (ds1 + ds2) * money[2]
  else
    cash = (ds1 + ds2) * money[3]
  end
  m_tr(plk, cash, pos)
  --rnd_txt(rules_group.bank.phrase, cash)
end
action_bank = function(plk)
  __action(plk, _action_bank)
end

-- Экшн таможни
action_jail = function(plk)
  local pl = current_game.players[plk]
  pl.pos = cell_jail
  pl.jail = 4
  local x, y = getplayerxy(cell_jail, plk)
  --pl:animate({x=x}, {speed=0.5}):animate({y=y}, {speed=0.5})
  --player:delay(1)
  --if lquery_fx == true then sound_jail:play() end
  --rnd_txt(reason_jail)
end

-- Экшн тюрьмы
action_jail_value = function(plk)
  local pl = current_game.players[plk]
  if pl.jail == 0 and math.random(1, 5) == 1 then 
    action_jail(pl)
    --rnd_txt(reason_jail_2)
  elseif pl.jail == 0 then
    --gui_text.text = action_phrase.jail
  end
end

-- Экшн шанса
cashback_chance = function(plk)
  math.randomseed(os.time() + os.clock() + math.random(99999))
  local chance = math.random(1, #rules_chance)
  --gui_text.text = rules_chance[chance].text
  rules_chance[chance].action(plk, rules_chance[chance])
  -- print("Chance: "..rules_chance[chance].money)
end

-- Отъем денег. функция для карточек
cashback = function(plk, chance)
  m_tr(plk, chance.money)
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
	math.randomseed(os.time() + os.clock() + math.random(99999))
	local treasury = math.random(1, #rules_treasury)
	gui_text.text = rules_treasury[treasury].text
	rules_treasury[treasury].action(player, rules_treasury[treasury])
-- print("Treasury: "..rules_chance[treasury].money)
end

-- Экшн острова
action_island = function(player)
	--gui_text.text = action_phrase.island
end

