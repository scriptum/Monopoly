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
  not_buy = false
auction_company = 0
bid_sum = 0
gui_text.text = ''
  playermenu_getvisible = false
  manuauction_getvisible = false
  current_player = 1
  current_player_temp = 0
  click_end_move = false
  auction_buyer = {0,0}
  num = #player._child - 1
  double = 1
  __i = 1
  gogo()
end

new_game = function()
  for k = 1, 5 do
    if initplayers[k] ~= 'Empty' then
      menuplayer:hide() -- меню опций игрока
      end_move:hide() -- кнопка перехода хода
      game_ower:hide() -- кнопка Сдаться
      gui_pay50k:hide() -- заплатить 50К и выйти из тюрьмы
      gui_shares_done:hide() -- покупка акций
      gui_mortgage_done:hide() -- кнопка Готово после залога
      gui_unmortgage_done:hide() -- кнопка Готово после продажи компании
      gamemenu:hide() -- Меню игры, вызываемое по эскейпу
--      menuvsettings:hide()
--      menusingle:hide()
      playermenu:show() -- родитель menuplayer
      board_gui:show() -- родитель отрисовки игроков с ценами в центре доски
      manuauction:hide()
      start_new_game()
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


__max = 5

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
  -- покупка компании
  if not_buy == false and buy_company(pl, pl.pos) == true then
    player:delay({speed = 0, cb = function() ai(pl) end})
    return
  elseif not_buy == false and rules_company[pl.pos].type ==  "company" and not rules_company[pl.pos].owner then
    auction2(pl, pl.pos, rules_company[pl.pos].money[1])
--    player:delay({speed = 0, cb = function() ai(pl) end})
    return
  end
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
  not_buy = false
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
    gogo()
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
	else
	  human_play(buf)
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
	gui_text.text = 'Вас поймали на подтосовке результата бросков. Отправляйтесь в тюрьму'
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
--  local company = rules_company[pl.pos]
  buy_company(pl, pl.pos)
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  end_move:show()
end

-- Функция обработки кнопки аукцион
human_auction = function()
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  local pl = player._child[current_player]
  auction2(pl, pl.pos)
end

human_click_company = function(company)
--Тут пишем обработку в зависимости от того в какой момент была нажата компания
--company имеет тип Entity!!!
  local pl = player._child[current_player]
  if gui_shares_done._visible == true then
    buybons_company(pl, rules_company[company.num])
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
    end
  elseif gui_unmortgage_done._visible == true then
    buyout_company(pl, rules_company[company.num], company.num)
  else
    buy_company(pl, company.num)
    company:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
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
  not_buy = false
  gui_pay50k:hide()
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

human_mortgage = function() 
  gui_text.text = l.mortgage_help
  for k, v in pairs(companys._child) do 
    local c = rules_company[v.num]
    if c.owner ~= player._child[current_player] or not c.owner then
      v:animate({all_alpha = 255}, 0.7)
    end
  end 
  gui_mortgage_done:menutoggle(menuplayer)
  if manuauction._visible == true then
    manuauction_getvisible = true
    manuauction:hide()
  end
end

human_unmortgage = function() 
  gui_text.text = l.unmortgage_help
  for k, v in pairs(companys._child) do 
    local c = rules_company[v.num]
    if not(c.owner == player._child[current_player] and c.level == 0) then
      v:animate({all_alpha = 255}, 0.7)
    end
  end 
  gui_unmortgage_done:menutoggle(menuplayer)
  if manuauction._visible == true then
    manuauction_getvisible = true
    manuauction:hide()
  end
end

human_shares = function() 
  gui_text.text = l.shares_help
  for k, v in pairs(companys._child) do 
    local c = rules_company[v.num]
    if not(c.owner == player._child[current_player] and c.level > 1) or (c.group == 'oil' or c.group == 'bank') then
      v:animate({all_alpha = 255}, 0.7)
    end
  end 
  gui_shares_done:menutoggle(menuplayer)
  if manuauction._visible == true then
    manuauction_getvisible = true
    manuauction:hide()
  end
end

human_shares_done = function() 
  gui_text.text = ''
  gui_shares_done:menutoggle(menuplayer)
  for k, v in pairs(companys._child) do
    v:animate({all_alpha = 0})
  end
  if manuauction_getvisible == true then
    manuauction_getvisible = false
    manuauction:show()
  end
end

human_mortgage_done = function() 
  gui_text.text = ''
  gui_mortgage_done:menutoggle(menuplayer)
  for k, v in pairs(companys._child) do
    v:animate({all_alpha = 0})
  end
  if manuauction_getvisible == true then
    manuauction_getvisible = false
    manuauction:show()
  end
end

human_unmortgage_done = function() 
  gui_text.text = ''
  gui_unmortgage_done:menutoggle(menuplayer)
  for k, v in pairs(companys._child) do
    v:animate({all_alpha = 0})
  end
  if manuauction_getvisible == true then
    manuauction_getvisible = false
    manuauction:show()
  end
end

--////////////////*****************************AUCTION*****************************////////////////

auction2 = function(pl, company)
  if company then
    auction_company = company
    auction_buyer[2] = rules_company[auction_company].money[1]
    bid_sum = auction_buyer[2]
  end
  if current_player_temp == 0 then current_player_temp = current_player end
  if num > 0 then
    local i = pl.k + 1
    if i > #player._child then i = i - #player._child end
    if player._child[i].ingame == true then
      current_player = i
      if initplayers[i] == 'Computer' then auction_ai(player._child[i])
      else auction_human(player._child[i]) end
    else
      num = num - 1
      auction2(player._child[i])
    end
  else
    if auction_buyer[1] ~= 0 then
      buy_company(player._child[auction_buyer[1]], auction_company, auction_buyer[2])
      companys._child[auction_company]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
      gui_text.text = rules_players_names[auction_buyer[1]]..' игрок купил компанию '..rules_company[auction_company].name..' за '..money(auction_buyer[2])
    end
    not_buy = true
    num = #player._child - 1
    auction_buyer = {0,0}
    auction_company = 0
    bid_sum = 0
    current_player = current_player_temp
    current_player_temp = 0
    if initplayers[player._child[current_player].k] == 'Human' then
      click_end_move = true
      end_move:show()
    else
      menuplayer:hide()
      ai(player._child[current_player])
    end
  end
end


auction_ai = function(pl)
  local new_sum = auction_buyer[2]
  if auction_buyer[1] ~= 0 then
    new_sum = math.floor(auction_buyer[2] + 0.1*auction_buyer[2])
  end
  --этот жопный иф, очевидно, отвечает за принятие решения о ставке
  local buy = false
  local gr = rules_company[auction_company].group
  local enemy_count = 0
  local different_owners = 0
  local owner_yourself = 0
  local last_owner = nil
  local gr_count = 0
  for k, v in pairs(rules_company) do
    if v.group == gr then 
      gr_count = gr_count + 1
      if v.owner then
	if v.owner == pl then
	  owner_yourself = owner_yourself + 1
	else
	  enemy_count = enemy_count + 1
	end
	if not last_owner or last_owner ~= v.owner then
	  last_owner = v.owner
	  different_owners = different_owners + 1
	end
      end
    end
  end
  local c = rules_company[auction_company].money[1]
  if different_owners < 2 and pl.cash >= new_sum and
     (
      enemy_count == gr_count - 1 and new_sum <= (c + c * 0.5) or
      owner_yourself == gr_count - 1 and new_sum <= c * 2 or
      new_sum == c
     ) then
  --if pl.cash >= new_sum and new_sum <= (rules_company[auction_company].money[1] + rules_company[auction_company].money[1]*0.5) then
    num = #player._child - 1
    auction_buyer = {pl.k, new_sum}
    bid_sum = new_sum
    gui_text.text = rules_players_names[pl.k]..' игрок сделал ставку '..money(new_sum)
    auction2(pl)
  else
    num = num - 1
    auction2(pl)
  end
end

auction_human_pl = 0

auction_human = function(pl)
  auction_human_pl = pl
  manuauction._child[1].text = '$ '..bid_sum..' K'
  if pl.cash >= auction_buyer[2] + 1 then manuauction._child[2].disabled = false
  else manuauction._child[2].disabled = true end
  manuauction._child[3].disabled = true
  if pl.cash >= auction_buyer[2] + 10 then manuauction._child[4].disabled = false
  else manuauction._child[4].disabled = true end
  manuauction._child[5].disabled = true
  if pl.cash >= auction_buyer[2] + 100 then manuauction._child[6].disabled = false
  else manuauction._child[6].disabled = true end
  manuauction._child[7].disabled = true
  if auction_buyer[1] == 0 and pl.cash >= auction_buyer[2] then manuauction._child[8].disabled = false
  else manuauction._child[8].disabled = true end
  manuauction._child[9].disabled = false
  manuauction:show()
  menuplayer:show()
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  end_move:hide()
  gui_pay50k:hide()
end

click_manuauction_button_bid = function()
    num = #player._child - 1
    auction_buyer = {auction_human_pl.k, bid_sum}
    manuauction:hide()
    gui_text.text = 'Игрок '..auction_human_pl.k..' сделал ставку '..money(bid_sum)
    auction2(auction_human_pl)
end

click_manuauction_button_pass = function()
    num = num - 1
    manuauction:hide()
    auction2(auction_human_pl)
end

click_manuauction_button = function(s)
  loadstring("bid_sum = bid_sum "..s.text)()
  manuauction._child[1].text = '$ '..bid_sum..' K'
  local difference = bid_sum - auction_buyer[2]
  menuplayer:show()
  menuplayer._child[1]:hide()
  menuplayer._child[2]:hide()
  if difference > 0 then
--*******************************************************************--
    if difference < 10 then
    if auction_human_pl.cash >= bid_sum + 1 then manuauction._child[2].disabled = false
    else manuauction._child[2].disabled = true end
      manuauction._child[3].disabled = false
    if auction_human_pl.cash >= bid_sum + 10 then manuauction._child[4].disabled = false
    else manuauction._child[4].disabled = true end
      manuauction._child[5].disabled = true
    if auction_human_pl.cash >= bid_sum + 100 then manuauction._child[6].disabled = false
    else manuauction._child[6].disabled = true end
      manuauction._child[7].disabled = true
      manuauction._child[8].disabled = false
--*******************************************************************--
    elseif difference < 100 then
    if auction_human_pl.cash >= bid_sum + 1 then manuauction._child[2].disabled = false
    else manuauction._child[2].disabled = true end
      manuauction._child[3].disabled = false
    if auction_human_pl.cash >= bid_sum + 10 then manuauction._child[4].disabled = false
    else manuauction._child[4].disabled = true end
      manuauction._child[5].disabled = false
    if auction_human_pl.cash >= bid_sum + 100 then manuauction._child[6].disabled = false
    else manuauction._child[6].disabled = true end
      manuauction._child[7].disabled = true
      manuauction._child[8].disabled = false
--*******************************************************************--
    else
    if auction_human_pl.cash >= bid_sum + 1 then manuauction._child[2].disabled = false
    else manuauction._child[2].disabled = true end
      manuauction._child[3].disabled = false
    if auction_human_pl.cash >= bid_sum + 10 then manuauction._child[4].disabled = false
    else manuauction._child[4].disabled = true end
      manuauction._child[5].disabled = false
    if auction_human_pl.cash >= bid_sum + 100 then manuauction._child[6].disabled = false
    else manuauction._child[6].disabled = true end
      manuauction._child[7].disabled = false
      manuauction._child[8].disabled = false
    end
  else
    if auction_human_pl.cash >= bid_sum + 1 then manuauction._child[2].disabled = false
    else manuauction._child[2].disabled = true end
    manuauction._child[3].disabled = true
    if auction_human_pl.cash >= bid_sum + 10 then manuauction._child[4].disabled = false
    else manuauction._child[4].disabled = true end
    manuauction._child[5].disabled = true
    if auction_human_pl.cash >= bid_sum + 100 then manuauction._child[6].disabled = false
    else manuauction._child[6].disabled = true end
    manuauction._child[7].disabled = true
    if auction_buyer[1] == 0 then manuauction._child[8].disabled = false
    else manuauction._child[8].disabled = true end
  end
end

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
      player._child[2].cash = player._child[2].cash - 1500
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
