--Все возможные действия игрока

--Предлагаю ВЕЗДЕ передавать номера а не объекты во избежание путаницы

-- Пересчет монополий
conversion_monopoly = function(plk, company_k)
	local rules_com = rules_company[company_k]
	local com = current_game.companys[company_k]
	local pl = current_game.players[plk]
	local oils_bank = {}
	local group  = 0
	local comp = {}
		-- если нефтяная компания или банк - считаем количество компаний
	if rules_com.group == "oil" or rules_com.group == "bank" then
		for k,v in pairs(current_game.companys) do
			if v.owner and v.owner == plk and rules_com.group == rules_company[k].group and v.level > 0 then
	table.insert(oils_bank, k)
			end
		end
		for _, v in pairs(oils_bank) do
			current_game.companys[v].level = #oils_bank + 2
			--отправка на клиент новый левел
			--msg_add('set_level', v, #oils_bank + 2)
		end
	-- просчет монополий для всех остальных компаний
	else
		for k,v in pairs(current_game.companys) do
			if rules_com.group == rules_company[k].group then
	group = group + 1
	if v.owner == plk and v.level > 0 then
		table.insert(comp, k)
	end
			end
		end
		-- если все компании в группе - ставим левел 2 (если левел меньше двух)
		if group == #comp then
			for _, v in pairs(comp) do
	if current_game.companys[v].level < 2 then
		current_game.companys[v].level = 2
		--отправка на клиент новый левел
		--msg_add('set_level', v, 2)
	end
			end
		end
	end
end

-- покупка компании
buy_company = function(plk, company, money)
	local pl = current_game.players[plk]
	local companys = current_game.companys
	if not money and rules_company[company].type == "company" then money = rules_company[company].money[1] end
	if not companys[company].owner and rules_company[company].type == "company" and pl.cash >= money then
		companys[company].owner = plk --внимание - присваиваем овнера - число!
		--отправляем на клиент действие смены владельца компании
		msg_add('set_owner', company, plk)
		conversion_monopoly(plk, company) -- пересчет монополий, оба параметра - числа
		pl.cash = pl.cash - money --отъем бабла на сервере
		msg_add('set_cash',plk,pl.cash) --отправлка на клиент новое состояние бабок
		return true
	else
		return false
	end
end

-- Залог компании
mortgage_company = function(pl, company, num)
	local comp = {}
	local group = 0
	if company.owner == pl and company.type == "company" and company.level > 0 then
		if company.group == "oil" or company.group == "bank" then
			if initplayers[current_player] == 'Human' then
	company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company)
			else
	player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) end})
			end
			money_transfer(company.money[1]/2, pl)
			return true
		else
			if company.level > 2 then
	if initplayers[current_player] == 'Human' then
		company.level = company.level - 1 conversion_monopoly(pl, company)
	else
		player:delay({speed = 0, cb = function() company.level = company.level - 1 conversion_monopoly(pl, company) end})
	end
	money_transfer(rules_group[company.group].upgrade, pl)
	return true
			elseif company.level == 1 then
	if initplayers[current_player] == 'Human' then
		company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company)
	else
		player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) end})
	end
	money_transfer(company.money[1]/2, pl)
	return true
			else
	for k,v in pairs(rules_company) do
		if company.group == v.group then
			group = group + 1
			if v.level == 2 then table.insert(comp, v) end
		end
	end
	if group == #comp then
		if initplayers[current_player] == 'Human' then
			company.level = 0
			companys._child[num]:animate({mortgage_alpha = 255})
			conversion_monopoly(pl, company) 
				for k,v in pairs(comp) do
		if v.level > 1 then v.level = 1 end
				end
		else
			player:delay({speed = 0, cb = function() company.level = 0 companys._child[num]:animate({mortgage_alpha = 255}) conversion_monopoly(pl, company) 
				for k,v in pairs(comp) do
		if v.level > 1 then v.level = 1 end
				end 
			end})
		end
		money_transfer(company.money[1]/2, pl)
		return true
	end
			end
		end
	end
	return false
end

-- Выкуп компаний
buyout_company = function(pl, company, num)
	if company.owner == pl and company.type == "company" and company.level == 0 and pl.cash > company.money[1] then
		if initplayers[current_player] == 'Human' then
			company.level = 1
			conversion_monopoly(pl, company) 
			companys._child[num]:animate({mortgage_alpha = 0, cb = function(s)s.mortgage_alpha=0 end})
		else
			player:delay({speed = 0, cb = function() 
	company.level = 1 
	conversion_monopoly(pl, company) 
	companys._child[num]:animate({mortgage_alpha = 0, cb = function(s)s.mortgage_alpha=0 end})
			end})
		end
		money_transfer(company.money[1]*(-1), pl)
		return true
	end
	return false
end

-- Прокачка компаний
buyshares_company = function(pl, company)
	if company.owner == pl and company.level >= 2 and company.level < 7 and company.group ~= "oil" and 
			company.group ~= "bank" and pl.cash >= rules_group[company.group].upgrade then
		if initplayers[current_player] == 'Human' then
			company.level = company.level + 1
		else
			player:delay({speed = 0, cb = function() company.level = company.level + 1 end})
		end
		money_transfer(rules_group[company.group].upgrade * (-1), pl)
		return true
	end
	return false
end
