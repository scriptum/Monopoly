--Все возможные действия игрока

-- Пересчет монополий
conversion_monopoly = function(pl, company)
  local oils_bank = {}
  local group  = 0
  local comp = {}
    -- если нефтяная компания или банк - считаем количество компаний
  if company.group == "oil" or company.group == "bank" then
    for k,v in pairs(rules_company) do
    if v.owner == pl and company.group == v.group and v.level > 0 then
	table.insert(oils_bank, v)
      end
    end
    for k,v in pairs(oils_bank) do
      v.level = #oils_bank + 2
    end
   -- просчет монополий для всех остальных компаний
    else
      for k,v in pairs(rules_company) do
	if company.group == v.group then
	  group = group + 1
	  if v.owner == pl and v.level > 0 then
	    table.insert(comp, v)
	  end
	end
    end
    -- если все компании в группе - ставим левел 2 (если левел меньше двух)
    if group == #comp then
      for k,v in pairs(comp) do
	if v.level < 2 then
	  v.level = 2
	end
      end
    end
  end
end

-- покупка компании
buy_company = function(plk, company, money)
  pl = current_game.players[plk]
  if not money and rules_company[company].type == "company" then money = rules_company[company].money[1] end
  if not rules_company[company].owner and rules_company[company].type == "company" and pl.cash >= money then 
    player:delay({speed = 0, cb = function() 
      rules_company[company].owner = pl
      conversion_monopoly(pl, rules_company[company])
      companys._child[company]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
    end})
    money_transfer(money * (-1), pl)
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