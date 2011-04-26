field_width = 11 --компаний по горизонтали
field_height = 6 --компаний по вертикали

local a = 12 --добавочный параметр для высоты боковых компаний
local s2 = (200+field_height*a)/5 --расчет ширины клетки компании
local s1 = (800-field_width*s2)/2 --расчет высоты клетки компании

board = E:new(screen) --игровая доска
--центральный прямоугольник
burn = E:new(board):border_image('data/gfx/fuzzy2.png', 7, 7, 7, 7):set({w=800 - s1*2+10,h=600 - s1*2 +10, blendMode = 'subtractive'}):move(s1 - 5,s1 - 5):color(255,246,208,199)
companys = E:new(board) --компании

local alpha = 30 --альфа канал для разделителя
local sep_padding = 5 --отступы для разделителя
local scaley = (s1-sep_padding*2)/16 -- масштаб для разделителя
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
E:new(board):draw(sep_draw)

local cell_padding = 4 --отступ внутри ячейки

--получает смещение в зависимости от позции компании
get_xy = function(i, side)
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

--ф-я формата денег
local money = function(m)
  if m >= 1000 then
    return '$ ' .. m/1000 .. ' M'
  else
    return '$ ' .. m .. ' K'
  end
end

render = {} --массив с функциями рендеринга клеток, для каждого типа своя

--рисование полупрозрачного прямоугольника, означающего что клетка куплена
local draw_fuzzy = function(x, y, sx, sy, side)
  local sx = s2/16
  local sy = s1/16
  local sx2 = (s2 + a)/16
  if side == 1 then 
    x = x - cell_padding
    G.draw(fuzzy, x, y, 0, sx, sy)
  elseif side == 2 then
    G.draw(fuzzy, x + s2, y - cell_padding, math.pi/2, sx2, sy)
  elseif side == 3 then 
    x = x - cell_padding
    y = y - cell_padding*2
    G.draw(fuzzy, x, y - s2 + cell_padding * 2, 0, sx, sy)
  elseif side == 4 then 
    x = x + cell_padding*2
    G.draw(fuzzy, x - cell_padding*3 + s1, y - cell_padding, math.pi/2, sx2, sy)
  end
end

--ф-я рендеринга для нормальной компании
render.company = function(s)
  local i = s.pos
  local x, y = get_xy(i, s.side)
  local _x, _y = x, y
  local sx = (s2 - cell_padding*2)/16
  local sy = (s1 - cell_padding*2)/16
  local com = rules_company[s.num]
  if com.owner then 
    local c = rules_player_colors[com.owner.k]
    c[4] = s.owner_alpha
    G.setColor(c)
    draw_fuzzy(x, y, sx, sy, s.side)
  end
  G.setColor(255, 255, 255)
  sx = (s2 - cell_padding * 2) / 128
  G.draw(rules_company_images[s.num], x, y, 0, sx)

  if com.group then
    sx = (s1 - s2 - cell_padding * 2) / 64
    local group = com.group
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
  
  if com.level > 0 then 
    if not com.owner then 
      txt = money(com.money[1])
    elseif com.group == 'bank' then 
      if com.level == 3 then
        txt = '$ '.. com.money[2] ..' K*N'
      else
        txt = '$ '.. com.money[3] ..' K*N'
      end
    elseif com.group == 'oil' then
      txt = money(com.money[2] * 2^(com.level - 3))
    elseif com.level == 1 then
      txt = money(com.money[2])
    elseif com.level == 2 then
      txt = money(com.money[2]*2)
    else
      txt = money(com.money[com.level])
    end
    Gprintf(txt, x - cell_padding, y + s2 - cell_padding * 2, s2, 'center')
  end
  
  
  --заложено?
  if s.mortgage_alpha > 0 then 
    G.setColor(0,0,0,185*s.mortgage_alpha/255)
    draw_fuzzy(_x, _y, (s2 - cell_padding*2)/16, sy, s.side)
    G.setColor(255,255,255,s.mortgage_alpha)
    if s.side == 3 then y = y + s1 - s2 end
    G.draw(lock, x - 4, y, 0, s2/128)
  elseif com.level and com.level > 2 then
    G.setColor(255,255,255)
    --акции
    local lvl = com.level - 2
    local img = action
    local offset_y = 0
    sx = 16/32
    if lvl == 5 then 
      img = all_actions
      lvl = 1
      sx = 16/32
      offset_y = -2
    end
    --~ if com.group == 'oil' then 
      --~ img = rules_group_images.oil 
      --~ sx = 16/64 
      --~ G.setBlendMode('multiplicative')
    --~ end
    offset = s2/2 - cell_padding - 10 - lvl*10/2 - 3
    for i = 1, lvl do 
      if s.side == 1 then
        G.draw(img, x + offset + i*10, y + s1 - 8 + offset_y, 0, sx)
      elseif s.side == 2 then
        G.draw(img, x + s2 - s1 - 8, y + offset + i*10 + 8, 0, sx)
      elseif s.side == 3 then
        G.draw(img, x + offset + i*10, y-5+ offset_y, 0, sx)
      elseif s.side == 4 then
        G.draw(img, x + s1 - 12, y + offset + i*10 + 8 , 0, sx)
      end
      
    end
  end
  
end

--ф-я рендеринга для больших спецклеток по углам
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

--ф-я рендеринга казны и шанса
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
  Gprintf(rules_company[s.num].name, x, y, s2+6, 'center')
  --G.rectangle('line', x,y,s2- cell_padding * 2,12)
end

--ф-я рендеринга налога
render.nalog = function(s)
  x, y = get_xy(s.pos, s.side)
  if s.side == 2 then
    x = 800 - s1
    y = s1 + s.pos * s2
  else
    x = 0
    y = 600 - s1 - 16*2 - s.pos * s2
  end
  G.setColor(0,0,0)
  G.setFont(console)
  G.fontSize = 15
  Gprintf(rules_company[s.num].name .. '\n' .. money(rules_company[s.num].money), x, y, s1, 'center')
  --G.rectangle('line', x,y,s1, s2)
end

local c = 1
local side = 1
local big_cell = 1 --старт тюрьма парковка и таможня
--сколько компаний + 4 клетки по углам
for i = 1, field_width*2 + field_height*2 + 4 do
 if rules_company[i].type == "company" then rules_company[i].level = 1 end
  if i == 1 or 
     i == 2 + field_width or 
     i == 3 + field_width + field_height or
     i == 4 + field_width * 2 + field_height then
       E:new(companys)
      :set({pos = big_cell, num = i})
      :draw(render[rules_group[rules_company[i].group].draw])
      big_cell = big_cell + 1
  else
    --хитрая расстановка сторон для каждой клетки
    --  1
    --4   2
    --  3
    --тут по горизонтали 11 а повертикали 6 штук
    if side % 2 == 1 and c > field_width or side % 2 == 0 and c > field_height then
      c = 1
      side = side + 1
    end
    E:new(companys)
    :set({pos = c, side = side, num = i, mortgage_alpha = 0})
    :draw(render[rules_group[rules_company[i].group].draw])
    c = c + 1
  end
end

board_gui = E:new(board)

--var = 0
--E:new(screen):image('data/gfx/krig_Aqua_button.png'):move(100,100):draggable()

--~ require('ui.slider')
--~ local ent = 'burn'
--~ E:new(screen):move(200,200+32):slider('R', 0, 255, {ent, 'r'})
--~ E:new(screen):move(200,200+32*2):slider('G', 0, 255, {ent, 'g'})
--~ E:new(screen):move(200,200+32*3):slider('B', 0, 255, {ent, 'b'})
--~ E:new(screen):move(200,200+32*4):slider('Alpha', 0, 255, {ent, 'a'})
--~ E:new(screen):move(200,200+32*5):list('Blend', {'alpha', 'additive', 'multiplicative', 'subtractive'}, {'alpha', 'additive', 'multiplicative', 'subtractive'}, {ent, 'blendMode'})

--функция рендеринга игрока
player_draw = function(s)
  sx = 30/64
  if gamemenu._visible == false then G.draw(rules_player_images[s.k], s1+10, s1+90 + s.k*30, 0, sx) end
  if s.ingame == true then 
    G.draw(rules_player_images[s.k], s.x, s.y, 0, sx) 
    if gamemenu._visible == false then Gprint(money(s.cash), s1+45, s1+97 + s.k*30) end
    G.setBlendMode('additive')
    G.setColor(255,255,255,s.blend_alpha)
    G.draw(rules_player_images[s.k], s.x, s.y, 0, sx)
    if gamemenu._visible == false then G.draw(rules_player_images[s.k], s1+10, s1+90 + s.k*30, 0, sx) end
    G.setBlendMode('alpha')
  else
    Gprint('Банкрот', s1+45, s1+97 + s.k*30)
  end
end

--кости
dice_draw = function(s)
  G.draw(dice[ds1 or 1], s.x, s.y, 0, 0.5)
  G.draw(dice[ds2 or 1], s.x + 66, s.y, 0, 0.5)
end

E:new(board_gui):draw(dice_draw):move(s1 + 10, s1 + 10)

--анимация передачи денех
coins = E:new(screen):image('data/gfx/gold_coin_single.png'):set({sx=24/64, sy=24/64}):hide()
money_transfer_param = {speed = 1, cb = function(s) s:hide() s.a = 255 end}
money_transfer = function(money, from, to)
  if to then 
    from.cash = from.cash - money
    to.cash = to.cash + money
  else
    from.cash = from.cash + money
  end
  player:delay({speed = 0, cb = function() 
    if lquery_fx == true then
      A.play(sound_coin)
    end
    coins:move(from.x + 3, from.y):show()
    if to then
      coins:animate({x = to.x + 3, y = to.y}, money_transfer_param)
    else
      if money < 0 then
        coins:animate({y = from.y - 24, a = 30}, money_transfer_param)
      else
        coins.y = from.y - 24
        coins:animate({y = from.y, a = 30}, money_transfer_param)
      end
    end
  end})
  player:delay(1)
end



--[[
local rag_upd = function(s)
G.setRenderTarget(s.fb)
G.setFont(console)
G.fontSize = 10*screen_scale
G.setColor(255,255,255)
Gprintf('Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.',0,s.oy,s.w*screen_scale)
G.setRenderTarget()
end
local drag_start = function(s, x, y)
  s._rag_y = y - s.oy
  _rag_object = s
end
local drag_end = function(s)
  _rag_object = nil
end
table.insert(lquery_hooks, function()
  local s = _rag_object
  if s then
    s.oy = mY - s._rag_y
    if s.oy > 0 then s.oy = 0 end
    rag_upd(s)
  end
end)


frame = E:new(screen):set({x = 300, y = s1, w = 400, h = 600-s1, oy = 0, fb = G.newFramebuffer( 400*screen_scale, (600-s1*2)*screen_scale )})
:draw(function(s)
G.draw(s.fb, s.x, s.y, 0, 1/screen_scale)
end):mousepress(drag_start):mouserelease(drag_end)
rag_upd(frame)
]]