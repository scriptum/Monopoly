local field_width = 11 --компаний по горизонтали
local field_height = 6 --компаний по вертикали

local a = 12
local s2 = (200+field_height*a)/5
local s1 = (800-field_width*s2)/2
local sep_padding = 5
local scaley = (s1-sep_padding*2)/16
local alpha = 30
j = 1
function love.keypressed(key, unicode)
   if key == 'b' then
      j = j + 0.1
   elseif key == 'a' then
      j = j - 0.1
   end
   local s2 = (200+6*a)/5
local s1 = (800-11*s2)/2
local sep_padding = 5
local scaley = (s1-sep_padding*2)/16
local alpha = 30
end

board = Entity:new(screen) --игрова€ доска
companys = Entity:new(board) --компании
--Entity:new(screen):border_image(G.newImage('data/gfx/krig_Aqua_button.png'), 13, 15, 13, 15):move(s1,s1):set({w = 800 - s1*2, h = 600 - s1*2})

local sep_draw_ver = function(x, y, sx) --рисует разделитель (вертикальный)
  G.setBlendMode('additive')
  G.setColor(255,255,255,alpha)
  G.draw(sep, x, y, 0, sx, scaley)
  G.setBlendMode('multiplicative')
  G.setColor(0,0,0,alpha*2)
  G.draw(sep, x - sx, y, 0, sx, scaley)
end


local sep_draw_hor = function(x, y, sx) --рисует разделитель (горизонтальный)
  G.setBlendMode('additive')
  G.setColor(255,255,255,alpha)
  G.draw(sep, x, y, math.pi/2, sx, scaley)
  G.setBlendMode('multiplicative')
  G.setColor(0,0,0,alpha*2)
  G.draw(sep, x, y - sx, math.pi/2, sx, scaley)
end

local sep_draw = function(s) --рисует разделители
  local sx = 800/G.getWidth()
  for i = 1, 12 do --верх и низ
    sep_draw_ver(s1-s2+s2*i,sep_padding, sx)
    sep_draw_ver(s1-s2+s2*i,600+sep_padding-s1, sx)
  end
  for i = 1, 7 do --лево и право
    sep_draw_hor(800-sep_padding,s1-s2-a+(s2+a)*i, sx)
    sep_draw_hor(s1-sep_padding,s1-s2-a+(s2+a)*i, sx)
  end
  G.setBlendMode('alpha')
end
--объект - разделители
Entity:new(board):draw(sep_draw)


local cell_padding = 4 --отступ внутри €чейки

local get_xy = function(i, side)
  if side == 1 then
    x = s1 - s2 + cell_padding + s2 * i
    y = 0
  elseif side == 2 then
    x = 800 - s2
    y = s1 - s2 - a + (s2 + a) * i + cell_padding
  elseif side == 3 then
    x = 800 - s1 + cell_padding - s2 * i
    y = 600 - s2 + cell_padding * 2
  elseif side == 4 then
    x = cell_padding
    y = 600 - s1 - (s2 + a) * i + cell_padding
  else
    if i == 1 or i == 4 then
      x = cell_padding * 2
    else
      x = 800 - s1 + cell_padding * 2
    end
    if i == 1 or i == 2 then
      y = cell_padding * 2
    else
      y = 600 - s1 + cell_padding * 2
    end
  end
  return x, y
end


--ф-€ формата денег
local money = function(m)
  if m >= 1000 then
    return '$ ' .. m/1000 .. ' M'
  else
    return '$ ' .. m .. ' K'
  end
end
render = {}
--ф-€ рендеринга дл€ нормальной компании
render.company = function(s)
  local i = s.pos
  local x, y = get_xy(i, s.side)
  local sx = (s2 - cell_padding*2)/16
  local sy = (s1 - cell_padding*2)/16
  local sx2 = (s2 + a)/16
  if rules_company[s.num].owner then 
    local c = rules_player_colors[rules_company[s.num].owner.k]
    c[4] = s.owner_alpha
    G.setColor(c)
    if s.side == 1 then
      G.draw(fuzzy, x, y, 0, sx, sy)
    elseif s.side == 2 then
      G.draw(fuzzy, x + s2, y - cell_padding, math.pi/2, sx2, sy)
    elseif s.side == 3 then
      G.draw(fuzzy, x, y - s2 + cell_padding * 2, 0, sx, sy)
    elseif s.side == 4 then
      G.draw(fuzzy, x - cell_padding*3 + s1, y - cell_padding, math.pi/2, sx2, sy)
    end
  end
  G.setColor(255, 255, 255)
  sx = (s2 - cell_padding * 2) / 128
  G.draw(rules_company_images[s.num], x, y, 0, sx)


  if rules_company[s.num].group then
    sx = (s1 - s2 - cell_padding * 2) / 64
    local group = rules_company[s.num].group
    if s.side == 1 then
      G.draw(rules_group_images[group], x + (s2 - sx * 64 - cell_padding*2) / 2, y + s2 + cell_padding, 0, sx)
    elseif s.side == 2 then
      G.draw(rules_group_images[group], x - s2 + cell_padding * 2, y + (s2 + a - sx * 64 - cell_padding*2) / 2, 0, sx)
    elseif s.side == 3 then
      G.draw(rules_group_images[group], x + (s2 - sx * 64 - cell_padding*2) / 2, y - s2 + cell_padding, 0, sx)
    elseif s.side == 4 then
      G.draw(rules_group_images[group], x + s2, y + (s2 + a - sx * 64 - cell_padding*2) / 2, 0, sx)
    end
  end
  
  --цена
  G.setColor(0,0,0)
  G.setFont(console)
  G.fontSize = 10
  if s.side == 3 then
    y = y - s2 - cell_padding/2
  end
  
  --if rules_company[s.num].group == 'bank' then
  --  txt = '$ ' .. rules_company[s.num].money[1] .. ' K * n'
  --else
    txt = money(rules_company[s.num].money[1])
  --end
  Gprintf(txt, x - cell_padding, y + s2 - cell_padding * 2, s2, 'center')
end


--ф-€ рендеринга дл€ больших спецклеток по углам
render.big_cell = function(s)
  if s.pos == 1 or s.pos == 4 then
    x = cell_padding * 2
  else
    x = 800 - s1 + cell_padding * 2
  end
  if s.pos == 1 or s.pos == 2 then
    y = cell_padding * 2
  else
    y = 600 - s1 + cell_padding * 2
  end
  G.draw(rules_company_images[s.num], x, y, 0, (s1 - cell_padding * 4) / 128)
end

--ф-€ рендеринга казны и шанса
render.chance = function(s)
  x, y = get_xy(s.pos, s.side)
  sx = (s2 - cell_padding * 2) / 128
  G.draw(rules_company_images[s.num], x, y, 0, sx)
  if s.side == 1 then
    y = y + s2
  else
    y = y - 16 - cell_padding * 2
  end
  G.setColor(0,0,0)
  G.setFont(console)
  G.fontSize = 15
  Gprintf(rules_company[s.num].name, x, y, s2 + cell_padding * 3)
  --G.rectangle('line', x,y,s2- cell_padding * 2,12)
end

--ф-€ рендеринга налога
render.nalog = function(s)
  x, y = get_xy(s.pos, s.side)
  if s.side == 2 then
    x = 800 - s1
    y = s1 + s.pos * s2
  else
    x = cell_padding
    y = 600 - s1 - 16*2 - s.pos * s2
  end
  G.setColor(0,0,0)
  G.setFont(console)
  G.fontSize = 15
  Gprintf(rules_company[s.num].name .. '\n' .. money(rules_company[s.num].money), x, y, s1, 'center')
  --G.rectangle('line', x,y,s2- cell_padding * 2,12)
end

local c = 1
local side = 1
local big_cell = 1 --старт тюрьма парковка и таможн€
--сколько компаний + 4 клетки по углам
for i = 1, field_width*2 + field_height*2 + 4 do
  if i == 1 or 
     i == 2 + field_width or 
     i == 3 + field_width + field_height or
     i == 4 + field_width * 2 + field_height then
       Entity:new(companys)
      :set({pos = big_cell, num = i})
      :draw(render[rules_group[rules_company[i].group].draw])
      big_cell = big_cell + 1
  else
    --хитра€ расстановка сторон дл€ каждой клетки
    --  1
    --4   2
    --  3
    --тут по горизонтали 11 а повертикали 6 штук
    if side % 2 == 1 and c > field_width or side % 2 == 0 and c > field_height then
      c = 1
      side = side + 1
    end
    Entity:new(companys)
    :set({pos = c, side = side, num = i})
    :draw(render[rules_group[rules_company[i].group].draw])
    c = c + 1
  end
end

burn = Entity:new(board):border_image('data/gfx/fuzzy2.png', 7, 7, 7, 7):set({w=800 - s1*2+10,h=600 - s1*2 +10, blendMode = 'subtractive'}):move(s1 - 5,s1 - 5):color(255,235,160,199)
--var = 0
--Entity:new(screen):image('data/gfx/krig_Aqua_button.png'):move(100,100):draggable({bound={100, 500, 100, 100}})

--[[require('ui.slider')
local ent = 'burn'
Entity:new(screen):move(200,200+32):slider('R', 0, 255, {ent, 'r'})
Entity:new(screen):move(200,200+32*2):slider('G', 0, 255, {ent, 'g'})
Entity:new(screen):move(200,200+32*3):slider('B', 0, 255, {ent, 'b'})
Entity:new(screen):move(200,200+32*4):slider('Alpha', 0, 255, {ent, 'a'})
Entity:new(screen):move(200,200+32*5):list('Blend', {'alpha', 'additive', 'multiplicative', 'subtractive'}, {'alpha', 'additive', 'multiplicative', 'subtractive'}, {ent, 'blendMode'})]]

--получить позицию игрока основыва€сь на номере клетке и самого игрока (нужно дл€ смещени€)
local getplayerxy = function(n, k)
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

--функци€ рендеринга игрока
local player_draw = function(s)
  sx = 30/64
  G.draw(rules_player_images[s.k], s.x, s.y, 0, sx)
  G.draw(rules_player_images[s.k], s1+10, s1+90 + s.k*30, 0, sx)
  Gprint(money(s.cash), s1+45, s1+97 + s.k*30)
  
  G.setBlendMode('additive')
  G.setColor(255,255,255,s.blend_alpha)
  G.draw(rules_player_images[s.k], s.x, s.y, 0, sx)
  G.draw(rules_player_images[s.k], s1+10, s1+90 + s.k*30, 0, sx)
  G.setBlendMode('alpha')
end

__i = 1
double = 0
__max = 5


-- искусственный интеллект
ai = function(s)
  local b = rules_company[s.pos]
  if not b.owner then 
    b.owner = s
    companys._child[s.pos]:set({owner_alpha = 0}):delay(0.1):animate({owner_alpha = 120})
    if type(b.money) == 'table' then s.cash = s.cash - b.money[1] end
  elseif type(b.money) == 'table' and b.money[2] and s ~= b.owner then 
    s.cash = s.cash - b.money[2]
    b.owner.cash = b.owner.cash + b.money[2]
    coins:move(s.x, s.y):show():animate({x = b.owner.x, y = b.owner.y}, {speed = 1, callback=function(s) s:hide() end})
  end
  s:stop('blend'):set({blend_alpha = 0})
  player:delay({callback=gogo})
end

--бросок кубиков
roll = function()
  math.randomseed(os.time() + time + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + time + math.random(99999))
  ds2 = math.random(1, 6)
end

-- ‘ункци€ перемещени€ игрока по полю.
gogo = function(s)
  local buf = s._child[__i]
  buf:animate({blend_alpha = 150}, {loop = true, queue = 'blend'})
  buf:animate({blend_alpha = 0}, {loop = true, queue = 'blend'})

  for i = 1, 30 do
   s:delay({queue = 'roll', speed = i/200, callback = roll})
  end   
  s:delay({queue = 'roll', speed = 0.5, callback = function(s)
    local buf = s._child[__i]
    buf.pos = buf.pos + ds1 + ds2
    local max = field_width*2 + field_height*2 + 4
    if buf.pos > max then buf.pos = buf.pos - max end
    local x, y = getplayerxy(buf.pos, buf.k)
    buf:stop('main'):animate({x=x,y=y},{callback = ai, speed = 1})
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
    if __i > __max then __i = 1 end
  end})
end

player = Entity:new(board):delay({callback=gogo})

for k = 1, 5 do
  x, y = getplayerxy(1, k)
  Entity:new(player)
  :draw(player_draw)
  :set({pos = 1, w = 30, h = 30, k = k, x = x, y = y, blend_alpha = 0, cash = 1500})
end

--кости
dice_draw = function(s)
  G.draw(dice[ds1 or 1], s.x, s.y, 0, 0.5)
  G.draw(dice[ds2 or 1], s.x + 66, s.y, 0, 0.5)
end

Entity:new(board):draw(dice_draw):move(s1 + 10, s1 + 10)

--анимаци€ передачи денех
coins = Entity:new(board):image('data/gfx/coins-icon.png'):set({sx=24/256, sy=24/256}):hide()