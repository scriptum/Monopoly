max = field_width*2 + field_height*2 + 4

start_new_game = function()
  player:stop()
  for k = 1, 5 do
    x, y = getplayerxy(1, k)
    player._child[k]:stop():set({pos = 1, w = 30, h = 30, k = k, x = x, y = y, jail = 0, ingame = (initplayers[k] ~= 'Empty'), blend_alpha = 0, cash = 1500})
  end
  for k = 1, max do
    if rules_company[k].type == "company" then
      rules_company[k].owner = nil
      rules_company[k].level = 1
      companys._child[k].mortgage_alpha = 0
    end
  end
  __i = 1
  gogo(player)
end

new_game = function()
  for k = 1, 5 do
    if initplayers[k] ~= 'Empty' then
      start_new_game()
--      menuplayer:hide()
--      end_move:hide()
      game_ower:hide()
--      gui_pay50k:hide()
--      gui_shares_done:hide()
--      gui_mortgage_done:hide()
--      gui_trade_done:hide()
--      gamemenu:hide()
--      menuvsettings:hide()
--      menusingle:hide()
      break
    end
  end
end

--получить позицию игрока основываясь на номере клетке и самого игрока (нужно для смещения)
getplayerxy = function(n, k)
  side = companys._child[n].side
  x, y = get_xy(companys._child[n].pos, side)
  if side == 1 then
    x = x + math.cos(k*math.pi)*14 + 8
    y = y + k*12 - 3
  elseif side == 2 then
    x = x + k*14 - 55
    y = y + math.cos(k*math.pi)*12 + 12
  elseif side == 3 then
    x = x + math.cos(k*math.pi)*12 + 8
    y = y + k*12 - 55
  elseif side == 4 then
    x = x + k*14 -15
    y = y + math.cos(k*math.pi)*12 + 12
  else
    x = x + k*14 -15
    y = y + math.cos(k*math.pi*0.5)*30 + 24
  end
  return x + cell_padding, y + cell_padding
end

__i = 1
double = 1
__max = 5
current_player = 1

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
buy_company = function(pl, company, money)
  if money == nil then money = company.money[1] end
  if not company.owner and company.type == "company" and pl.cash >= money then 
    player:delay({speed = 0, cb = function() 
      company.owner = pl
      conversion_monopoly(pl, company)
      companys._child[pl.pos]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
    end})
    money_transfer(money * (-1), pl)
    return true
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
	  --print("pledge_company: "..company.name.." cash: "..company.money[1]/2)
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
buybons_company = function(pl, company)
  if company.owner == pl and company.level >= 2 and company.level < 7 and company.group ~= "oil" and 
	    company.group ~= "bank" and pl.cash > rules_group[company.group].upgrade then
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

--[[
-- Вылет из игры
gameout = function(pl)
  for k,v in pairs(rules_company) do
    if v.owner == pl then
      v.owner = nil
      v.level = 1
      companys._child[k].mortgage_alpha = 0
    end
  end
  pl.ingame = false
end

comp = 0
-- Функция залога компаний для AI
mortgage_ai = function(pl)
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do
      mortgage_company(pl, v, k)
      if pl.cash >= 0 then break end
    end
    if pl.cash < 0 then
      print("if")
      player:delay({speed=0, cb = function()
	for k,v in pairs(rules_company) do
	  if v.owner == pl and v.level > 0 then
	    comp = 1
	    break
	  end
	end
	print(comp)
	if comp == 1 then
	  comp = 0
	  mortgage_ai(pl)
	end
      end})
    end
  end
end]]

angles = {1, 13, 20, 32}

--функция движения по полю
moove = function(pl, x)
  if pl.jail == 0 then
    local pl_x, pl_y
    local last_cell = 0
    -- добавляем все углы, по которым проходим
    for i=1, x do
      pl.pos = pl.pos + 1
      if pl.pos > max then
	pl.pos = pl.pos-max
      end
      if table.find(angles, pl.pos) > 0 then
	pl_x, pl_y = getplayerxy(pl.pos, pl.k)
	pl:animate({x=pl_x, y=pl_y},{speed=0.7})
	last_cell = pl.pos
      end
    end
    if pl.pos ~= last_cell then
      pl_x, pl_y = getplayerxy(pl.pos, pl.k)
      pl:animate({x=pl_x, y=pl_y},{speed=0.7})
    end
  end
end

--////////////////*****************************AI*****************************////////////////
-- искусственный интеллект
ai = function(pl)
-- если денег меньше нуля - закладываем компании
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do
      if v.owner == pl and v.level == 1 and mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
    for k,v in pairs(rules_company) do
      if mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end

  -- игрок вылетает
  player:delay({speed = 0, cb = function()
    if pl.cash < 0 then
      for k,v in pairs(rules_company) do
	if v.owner == pl then
	  v.owner = nil
	  v.level = 1
	  companys._child[k].mortgage_alpha = 0
	end
      end
      pl.ingame = false
      pl.pos = 1
      sound_out:play()
    end
  end})

--  if rules_company[pl.pos].type == "company" and not rules_company[pl.pos].owner and pl.cash >= (rules_company[pl.pos].money[1] + 200) then
    if buy_company(pl, rules_company[pl.pos])  == true then
      player:delay({speed = 0, cb = function() ai(pl) end})
      return
    end
--  end

-- прокачка компаний
  for k,v in pairs(rules_company) do
    if v.type == "company" and v.owner == pl and pl.cash >= (rules_group[v.group].upgrade) then
      if buybons_company(pl, v) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  -- выкуп компаний
  for k,v in pairs(rules_company) do
    if v.type == "company" and v.owner == pl and pl.cash >= (v.money[1] + 200) then
      if buyout_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  player:delay({callback=gogo})
  player:delay({speed = 0, cb = function()pl:stop('blend'):set({blend_alpha = 0})end})
end

--////////////////*****************************HUMAN_PLAY*****************************////////////////
-- Функция игрока
human_play = function()
  local pl = player._child[current_player]
  local company = rules_company[pl.pos]
  if company.type == 'company' and not company.owner then
    end_move:hide()
    menuplayer._child[2]:show()
    if pl.cash >= company.money[1] then
      menuplayer._child[1]:show()
    else
      menuplayer._child[1]:hide()
    end
  else
    if pl.jail > 1 and pl.cash >= 50 then
      gui_pay50k:show()
    end
    menuplayer._child[1]:hide()
    menuplayer._child[2]:hide()
    end_move:show()
  end
  if pl.cash < 0 then
    game_ower:show()
    menuplayer._child[1]:hide()
    menuplayer._child[2]:hide()
    end_move:hide()
  end
  menuplayer:show()
end

--бросок кубиков
roll = function()
  math.randomseed(os.time() + time + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + time + math.random(99999))
  ds2 = math.random(1, 6)
end
statistics = {
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0}

--////////////////*****************************GOGO*****************************////////////////
-- Функция перемещения игрока по полю.
gogo = function()
  local buf = player._child[__i]
  if buf.ingame == false or (buf.jail == 4 and double > 1) then 
    double = 1
    __i = __i + 1
    if __i > #player._child then __i = 1 end
    --player:delay({callback=gogo})
    gogo(s)
  else 
    player:delay({speed = 0, cb = function()
      buf:animate({blend_alpha = 150}, {loop = true, queue = 'blend'})
      buf:animate({blend_alpha = 0}, {loop = true, queue = 'blend'})
    end})
    current_player = __i
    if lquery_fx == true then
      --звук костей
      local i = math.random(1,6)
      sound_dice[i]:setPitch(0.8 + math.random()/3)
      A.play(sound_dice[i])
      local j = i 
      while i == j do j = math.random(1,6) end
      sound_dice[j]:setPitch(0.8 + math.random()/3)
      A.play(sound_dice[j])
      for i = 1, 19 do
	buf:delay({queue = 'roll', speed = i/200, callback = roll})
      end
    else
      buf:delay({queue = 'roll', speed = 0, callback = roll})
    end

    buf:delay({queue = 'roll', speed = 1, callback = function(s)
      local fromjail = false
      if buf.jail > 0 then
	if ds1 == ds2 then
	  buf.jail = 0
	  fromjail = true
	  if initplayers[buf.k] == 'Human' then gui_pay50k:hide() end
	elseif buf.jail > 2 then
	  buf.jail = buf.jail - 1
	elseif buf.jail == 2 then
	  buf.jail = buf.jail - 1
	  money_transfer(-50, buf)
	  if initplayers[buf.k] == 'Human' then gui_pay50k:hide() end
--	  buf.cash = buf.cash - 50
	else
	  buf.jail = 0
	  if initplayers[buf.k] == 'Human' then gui_pay50k:hide() end
	end
      end
--      local buf = player._child[__i]
      local add_money = false
      if buf.pos + ds1 + ds2 > max then
	add_money = true
      end
      moove(buf, ds1+ds2)
      buf:delay({speed=0, callback = function(s)
	if add_money == true then
	  money_transfer(200, buf)
	end
	local cell = rules_company[buf.pos]
	if cell.action then cell.action(buf) end
-- выбор игрок живой илди комп
	if initplayers[buf.k] == 'Computer' then
	  ai(buf)
--	  print(initplayers[buf.k])
	else
	  human_play(buf)
--	  print(initplayers[buf.k])
	end
	statistics[buf.pos] = statistics[buf.pos] + 1
      end})
      if ds1 ~= ds2 or fromjail == true then
	__i = __i + 1
  --      if __i > 5 then __i = 1 end
	double = 1
      elseif double < 3 then
	double = double + 1
      else
	buf.pos = cell_jail
	if jquery_fx then sound_jail:play() end
	local x, y = getplayerxy(cell_jail, buf.k)
	buf:stop('main'):animate({x=x,y=y}):stop('blend'):set({blend_alpha = 0})
	player:delay({callback=gogo})
	double = 1
	buf.jail = 4
	__i = __i + 1
      end
      fromjail = false
      if __i > #player._child then __i = 1 end
    end})
  end
end

player = E:new(board)

for k = 1, 5 do
  E:new(player)
  :draw(player_draw)
end

start_new_game()

-- Обработка клика покупки компании
human_buy_company = function()
  local pl = player._child[current_player]
  local company = rules_company[pl.pos]
  buy_company(pl, company)
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  end_move:show()
end

-- Функция обработки кнопки аукцион
human_auction = function()
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  click_end_move = true
  end_move:show()
end

click_end_move = false

human_click_company = function(company)
--Тут пишем обработку в зависимости от того в какой момент была нажата компания
--company имеет тип Entity!!!
  local pl = player._child[current_player]
  if gui_shares_done._visible == true then
    buybons_company(pl, rules_company[company.num])
--    print('buybons_company')
  elseif gui_mortgage_done._visible == true then
    mortgage_company(pl, rules_company[company.num], company.num)
    if pl.cash > 0 then
      game_ower:hide()
      if rules_company[pl.pos].type == 'company' and not rules_company[pl.pos].owner and click_end_move ~= true then
	menuplayer._child[2]:show()
	if pl.cash >= rules_company[pl.pos].money[1] then
	  menuplayer._child[1]:show()
	else
	  menuplayer._child[1]:hide()
	end
      else
	end_move:show()
      end
--      end_move:show()
    end
--    print('mortgage_company')
  elseif gui_trade_done._visible == true then
    buyout_company(pl, rules_company[company.num], company.num)
--    print('buyout_company')
  else
    buy_company(pl, rules_company[company.num])
    company:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
--    print('buy_company')
  end
end

for k, v in pairs(companys._child) do
  v:click(human_click_company)
end 

-- Обработка кнопки переход хода
turn = function()
  menuplayer:hide()
  local pl = player._child[current_player]
  pl:stop('blend'):set({blend_alpha = 0})
  click_end_move = false
  gogo()
end

-- Обработка кнопки Сдаться
game_ower = function()
  menuplayer:hide()
  local pl = player._child[current_player]
  pl:stop('blend'):set({blend_alpha = 0})
  for k,v in pairs(rules_company) do
    if v.owner == pl then
      v.owner = nil
      v.level = 1
      companys._child[k].mortgage_alpha = 0
    end
  end
  pl.ingame = false
  pl.pos = 1
  sound_out:play()
  gogo()
end

-- Кнопка оплаты выхода из тюрьмы
pay50k = function()
  local pl = player._child[current_player]
  if pl.cash >= 50 then
    money_transfer(-50, pl)
    pl.jail = 0
  end
  gui_pay50k:hide()
end

auction_buyer = {0,0}

auction = function(pl, company, sum)
  local stop_for = start_for + #player._child
  local start_for = pl.k + 1
  local j = 0
  local auction_buy = false

  for i = start_for, stop_for do
    j = i
    if j > #player._child then j = j - #player._child end
    if player._child[j].ingame == true and player._child[j].cash >= sum then
      if initplayers[buf.k] == 'Computer' then
	auction_buy = auction_ai(player._child[j], company, sum + 0.1*sum)
	if auction_buy == true then
	  auction_buyer[1] = player._child[j]
	  auction_buyer[2] = sum + 0.1*sum
	  auction(player._child[j], company, sum + 0.1*sum)
--	  break
	  return
	end
      else
	auction_human(player._child[j], company, sum + 0.1*sum)
	return
      end
    end
  end

end

auction_ai = function(pl, company, sum)
  if pl.cash >= sum and sum <= (company.money[1] + company.money[1]*0.5) then
    return true
  else
    return false
  end
end

auction_human = function(pl, company, sum)
  
end

playermenu_getvisible = false

function love.keyreleased( key, unicode )
   if key == "1" then
      player._child[1].cash = player._child[1].cash - 1000
   end
   if key == "n" then
      new_game()
   end
     if key == "q" then
      player._child[1].cash = player._child[1].cash + 100
   end
   if key == "2" then
      player._child[2].cash = player._child[2].cash - 1000
   end
   if key == "3" then
      player._child[3].cash = player._child[3].cash - 1000
   end
   if key == "f" then 
     lquery_fx = not lquery_fx 
   end
   if key == "escape" then
     gamemenu:toggle()
     if playermenu._visible == true then
       playermenu:toggle()
       playermenu_getvisible = true
     elseif playermenu_getvisible == true then
       playermenu_getvisible = false
       playermenu:toggle()
     end
     board_gui:toggle()
   end
end
