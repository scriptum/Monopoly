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
  return x, y
end



__i = 1
double = 0
__max = 5
--[[
cashback = function(s, cash)
 if s.cash > cash then
  return s.cash - cash
 else 
  for k,v pairs(rules_company) do
   if v.owner == s.owner then
    v.level = 0
    s.cash = s.cash + v.money[1]/2
    if s.cash >= cash then break end
   end
  end
 end
end
]]--

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
buy_company = function(player, company)
  if not company.owner and company.type == "company" and player.cash > company.money[1] then
    company.owner = player
    conversion_monopoly(player, company)
    companys._child[player.pos]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 90})
    money_transfer(company.money[1] * (-1), player)
    return true
  end
end

-- Залог компании
mortgage_company = function(player, company)
  local comp = {}
  local group = 0
  if company.owner == player and company.type == "company" and company.level > 0 then
    if company.group == "oil" or company.group == "bank" then
      company.level = 0
    else
      if company.level > 2 then
	company.level = company.level - 1
	money_transfer(rules_group[company.group].upgrade, player)
      elseif company.level == 1 then
	company.level = 0
	money_transfer(company.money[1]/2, player)
      else
	for k,v in pairs(rules_company) do
	  if company.group == v.group then
	    group = group + 1
	    if v.level == 2 then table.insert(comp, v) end
	  end
	end
	if group == #comp then
	  company.level = 0
	  --print("pledge_company: "..company.name.." cash: "..company.money[1]/2)
	  money_transfer(company.money[1]/2, player)
	  for k,v in pairs(comp) do
	    if v.level > 1 then v.level = 1 end
	  end
	end
      end
    end
  conversion_monopoly(player, company)
  end
end

-- Выкуп компаний
buyout_company = function(player, company)
  if company.owner == player and company.type == "company" and company.level == 0 and player.cash > company.money[1] then
    company.level = 1
    conversion_monopoly(player, company)
    money_transfer(company.money[1] * (-1), player)
  end
end

-- Прокачка компаний
buybons_company = function(player, company)
  if company.owner == player and company.level >= 2 and company.level < 7 and company.group ~= "oil" and 
	    company.group ~= "bank" and player.cash > rules_group[company.group].upgrade then
    company.level = company.level + 1
    money_transfer(rules_group[company.group].upgrade * (-1), player)
  end
end

-- искусственный интеллект
ai = function(pl)
-- если денег меньше нуля - закладываем компании
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do  
      mortgage_company(pl, v)
      if pl.cash >= 0 then break end
    end
  end
  buy_company(pl, rules_company[pl.pos])
-- выкуп компаний
  for k,v in pairs(rules_company) do buyout_company(pl, v) end
-- прокачка компаний
  for k,v in pairs(rules_company) do buybons_company(pl, v) end
  
end

--бросок кубиков
roll = function()
  math.randomseed(os.time() + time + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + time + math.random(99999))
  ds2 = math.random(1, 6)
end

-- Функция перемещения игрока по полю.
gogo = function(s)
  local buf = s._child[__i]
  buf:animate({blend_alpha = 150}, {loop = true, queue = 'blend'})
  buf:animate({blend_alpha = 0}, {loop = true, queue = 'blend'})

  --звук костей
  local i = math.random(1,6)
  sound_dice[i]:setPitch(0.8 + math.random()/3)
  A.play(sound_dice[i])
  local j = i 
  while i == j do j = math.random(1,6) end
  sound_dice[j]:setPitch(0.8 + math.random()/3)
  A.play(sound_dice[j])
  
  for i = 1, 19 do
   s:delay({queue = 'roll', speed = i/200, callback = roll})
  end   
  s:delay({queue = 'roll', speed = 1, callback = function(s)
    local buf = s._child[__i]
    buf.pos = buf.pos + ds1 + ds2
    local max = field_width*2 + field_height*2 + 4
    if buf.pos > max then
     buf.pos = buf.pos - max
     buf.cash = buf.cash + 200
    end
    local x, y = getplayerxy(buf.pos, buf.k)
    buf:stop('main'):animate({x=x,y=y},{callback = function(s)
     local cell = rules_company[s.pos]
     if cell.action then cell.action(s) end
     ai(s)
     s:stop('blend'):set({blend_alpha = 0})
     player:delay({callback=gogo})
    end, speed = 0.5})
    if ds1 ~= ds2 then
     __i = __i + 1
     if __i > 5 then __i = 1 end
     double = 0
    elseif double < 3 then
     double = double + 1
    else
     buf.pos = 13
     local x, y = getplayerxy(13, buf.k)
     buf:stop('main'):animate({x=x,y=y}):stop('blend'):set({blend_alpha = 0})
     player:delay({callback=gogo})
     double = 0
     buf.jail = 3
     __i = __i + 1
    end
    if __i > #player._child then __i = 1 end
  end})
end

player = Entity:new(board):delay({callback=gogo})

for k = 1, 2 do
  x, y = getplayerxy(1, k)
  Entity:new(player)
  :draw(player_draw)
  :set({pos = 1, w = 30, h = 30, k = k, x = x, y = y, blend_alpha = 0, cash = 1500})
end


function love.keyreleased( key, unicode )
   if key == "1" then
      player._child[1].cash = player._child[1].cash - 100
   end
     if key == "q" then
      player._child[1].cash = player._child[1].cash + 100
   end
   if key == "2" then
      player._child[2].cash = player._child[2].cash - 1000
   end
end
