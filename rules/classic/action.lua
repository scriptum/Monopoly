field_width = 11 --компаний по горизонтали
field_height = 7 --компаний по вертикали
cell_jail = 13 --на какой клетке тюрьма
--подсчитаем общее число клеток: высота, ширина и 4 угловых
cell_count = field_width * 2 + field_height * 2 + 4

local rnd_txt = function(a, s)
	if s and a then 
		gui_text.text = a[math.random(1, #a)]:gsub('%%', money(s))
	elseif a then
		gui_text.text = a[math.random(1, #a)]
	end
end

local money_transfer = function(money, from, to)
	local pl = current_game.players[from]
	pl.cash = pl.cash - money
	msg_add('set_cash', from, pl.cash)
	if to then
		local pl2 = current_game.players[to]
		pl2.cash = pl2.cash + money
		msg_add('set_cash', to, pl2.cash)
	end
	msg_add('cash_trans', money, from, to)
end

local m_tr = function(plk, cash, pos)
	local to = nil
	if pos then
		to = current_game.companys[pos].owner
	end
	money_transfer(cash, plk, to)
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
		cash = (dice1 + dice2) * money[2]
	else
		cash = (dice1 + dice2) * money[3]
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
	--какаято хрень постоянно тут вылетает
	--pl.pos = cell_jail
	--pl.jail = 4
	--local x, y = getplayerxy(cell_jail, plk)
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
action_birthday = function(plk, card)
	local m = card.money
	local players = current_game.players
	for i = 1, __max do
		-- print(players, players[i])
		if players[i] and players[i].ingame == true and players[i].k ~= plk then
			money_transfer(m, players[i].k, plk)
		end
	end
end

local function company_can_upgrade(company_number)
	local com = rules_company[company_number]
	return com.type == "company" and com.group ~= "bank" and com.group ~= "oil"
end

-- Оплата каждой акции. функция для карточек
tax_on_shares = function(plk, card)
	local shares = 0
	for i = 1, cell_count do
		local com = current_game.companys[i]
		if company_can_upgrade(i) and com.owner == plk and com.level > 2 then
			shares = shares + com.level - 2
		end
	end
	if shares > 0 then
		money_transfer(card.money * shares, plk)
	end
end

-- Экшн казны
cashback_treasury = function(plk)
	math.randomseed(os.time() + os.clock() + math.random(99999))
	local treasury = math.random(1, #rules_treasury)
	--gui_text.text = rules_treasury[treasury].text
	rules_treasury[treasury].action(plk, rules_treasury[treasury])
-- print("Treasury: "..rules_chance[treasury].money)
end

-- Экшн острова
action_island = function(player)
	--gui_text.text = action_phrase.island
end

