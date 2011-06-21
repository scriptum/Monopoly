


cw = 56 --расчет ширины клетки компании
ch = (800-cw*field_width)/2 --расчет высоты клетки компании
a = (600-ch*2)/field_height - cw --добавочный параметр для высоты боковых компаний
cell_padding = 2 --отступ внутри ячейки
font_size = 10
board = E:new(screen) --игровая доска
--центральный прямоугольник
burn = E:new(board):border_image('data/gfx/fuzzy2.png', 7, 7, 7, 7):set({w=800 - ch*2+10,h=600 - ch*2 +10, blendMode = 'subtractive'}):move(ch - 5,ch - 5):color(255,246,208,100)
companys = E:new(board) --компании

local alpha = 30 --альфа канал для разделителя
local sep_padding = 5 --отступы для разделителя
scaley = (ch-sep_padding*2) -- масштаб для разделителя
local sep_draw_ver = function(x, y, sx) --рисует разделитель (вертикальный)
  S.setBlendMode('additive')
  S.setColor(255,255,255,alpha)
  sep:draw(x, y, 0, sx, scaley)
  S.setBlendMode('multiplicative')
  S.setColor(0,0,0,alpha*2)
  sep:draw(x - sx, y, 0, sx, scaley)
end

local sep_draw_hor = function(x, y, sx) --рисует разделитель (горизонтальный)
  S.setBlendMode('additive')
  S.setColor(255,255,255,alpha)
  sep:draw(x, y, 90, sx, scaley)
  S.setBlendMode('multiplicative')
  S.setColor(0,0,0,alpha*2)
  sep:draw(x, y - sx, 90, sx, scaley)
end

local sep_draw = function(s) --рисует разделители
  local sx = 1/screen_scale
  for i = 1, field_width + 1 do --верх и низ
    sep_draw_ver(ch-cw+cw*i,sep_padding, sx)
    sep_draw_ver(ch-cw+cw*i,600+sep_padding-ch, sx)
  end
  for i = 1, field_height + 1 do --лево и право
    sep_draw_hor(800-sep_padding,ch-cw-a+(cw+a)*i, sx)
    sep_draw_hor(ch-sep_padding,ch-cw-a+(cw+a)*i, sx)
  end
  S.setBlendMode('alpha')
end

--объект - разделители
E:new(board):draw(sep_draw)


--получает координаты левого верхнего угла клетки в зависимости от позции компании
get_xy = function(i, side)
  if side == 1 then
    x = ch - cw + cw * i
    y = 0
  elseif side == 2 then
    x = 800 - ch
    y = ch - cw - a + (cw + a) * i
  elseif side == 3 then
    x = 800 - ch - cw * i
    y = 600 - ch
  elseif side == 4 then
    x = 0
    y = 600 - ch - (cw + a) * i
  else
    if i == 1 or i == 4 then
      x = 0
    else
      x = 800 - ch
    end
    if i == 1 or i == 2 then
      y = 0
    else
      y = 600 - ch
    end
  end
  return x, y
end

--грузим массивы смещений внутри клетки
require('rules/classic/offsets')

--грузим функцию форматирования денег
require('rules/classic/money')

draw = {} --массив с функциями рендеринга клеток, для каждого типа своя

--рисование полупрозрачного прямоугольника, означающего что клетка куплена
local draw_fuzzy = function(x, y, sx, sy, side)
  if side == 1 or side == 3 then
    fuzzy:draw(x, y, 0, cw, ch)
  else
    fuzzy:draw(x, y, 0, ch, cw)
  end
end

--ф-я рендеринга для нормальной компании
draw.company = function(s)
  fnt_small:select()
  local i = s.pos
  x, y = get_xy(i, s.side)
  local _x, _y = x, y
  local sx = (cw - cell_padding*2)/16
  local sy = (ch - cell_padding*2)/16
  local com = rules_company[s.num]
  --закраска клетки владельцем
  if com.owner then 
    local c = rules_player_colors[com.owner.k]
    c[4] = s.owner_alpha
    S.setColor(c)
    draw_fuzzy(x, y, sx, sy, s.side)
  end
  S.setColor(255, 255, 255, s.logo_hover/5)
  S.setBlendMode('additive')
  draw_fuzzy(x, y, sx, sy, s.side)
  S.setBlendMode('alpha')
  S.setColor(255, 255, 255, 255)
  --отрисовка картинки компании
  rules_company_images[s.num]:draw(x + offset_logo[s.side].x, y + offset_logo[s.side].y, 0, offset_logo[s.side].w)
  --отрисовка группы
  if com.group then rules_group_images[com.group]:draw(x + offset_group[s.side].x, y + offset_group[s.side].y, 0, offset_group[s.side].w) end
  
  S.setColor(0,0,0,185*math.max(s.mortgage_alpha, s.all_alpha)/255)
  draw_fuzzy(_x, _y, (cw - cell_padding*2)/16, sy, s.side)
  --заложено?
  if s.mortgage_alpha > 0 then 
    
    S.setColor(255,255,255,s.mortgage_alpha)
    if s.side == 3 then y = 600 - cw end
    if com.level == 0 then 
      S.setColor(255,255,255,255 - s.all_alpha)
      lock:draw(x - 4, y, 0, cw) 
    end
  elseif com.level and com.level > 2 then
    S.setColor(255,255,255)
    --акции
    local lvl = com.level - 2
    local img = action
    local offset_y = 0
    sx = 16
    if lvl == 5 then 
      img = all_actions
      lvl = 1
      sx = 16
      offset_y = -2
    end
    offset = cw/2 - cell_padding - 10 - lvl*10/2 - 3
    for i = 1, lvl do 
      if s.side == 1 then
        img:draw(x + offset + i*10, y + ch - 8 + offset_y, 0, sx)
      elseif s.side == 2 then
        img:draw(x + cw - ch - 8, y + offset + i*10 + 8, 0, sx)
      elseif s.side == 3 then
        img:draw(x + offset + i*10, 600 - ch - 8, 0, sx)
      elseif s.side == 4 then
        img:draw(x + ch - 12, y + offset + i*10 + 8 , 0, sx)
      end
      
    end
  end
  
    --цена
  S.setColor(offset_rent_color)
  --~ S.setFont(console)
  --~ S.fontSize = offset_rent[s.side].size
  local txt = nil
  if gui_mortgage_done._visible == true and com.owner and com.owner.k == current_player and com.level > 0 then
    txt = money(com.money[1]/2)
  --~ elseif gui_shares_done._visible == true and com.owner and com.owner.k == current_player and com.level > 1 then
    --~ txt = money(rules_group[com.group].upgrade)
  elseif gui_unmortgage_done._visible == true and com.owner and com.owner.k == current_player and com.level == 0 then
    txt = money(com.money[1])
    S.setColor(255,255,255)
  elseif com.level > 0 then 
    if not com.owner then 
      txt = money(com.money[1])
    elseif com.group == 'bank' then 
      if com.level == 3 then
        txt = '$'.. com.money[2] ..'K*N'
      else
        txt = '$'.. com.money[3] ..'K*N'
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
  end
  if txt then Gprintf(txt, x + offset_rent[s.side].x , y + offset_rent[s.side].y, offset_rent[s.side].w, 'center') end
end

--ф-я рендеринга для больших спецклеток по углам
draw.big_cell = function(s)
  local x, y = get_xy(s.pos, s.side)
  rules_company_images[s.num]:draw(x + cell_padding, y + cell_padding, 0, (ch - cell_padding * 4))
end

--ф-я рендеринга казны и шанса
draw.chance = function(s)
  fnt_small:select()
  local x, y = get_xy(s.pos, s.side)
  rules_company_images[s.num]:draw(x + offset_chest[s.side].x, y + offset_chest[s.side].y, 0, offset_chest[s.side].w)
  S.setColor(offset_rent_color[1], offset_rent_color[2], offset_rent_color[3], 255)
  --~ S.setFont(console)
  S.fontSize = offset_chest_text[s.side].size
  Gprintf(rules_company[s.num].name, x, y + offset_chest_text[s.side].y, offset_chest_text[s.side].w, 'center')
end

--ф-я рендеринга налога
draw.nalog = function(s)
  fnt_small:select()
  local x, y = get_xy(s.pos, s.side)
  rules_company_images[s.num]:draw(x + offset_logo[s.side].x, y + offset_logo[s.side].y, 0, offset_logo[s.side].w)
  S.setColor(offset_rent_color)
  --~ S.setFont(console)
  S.fontSize = offset_chest_text[s.side].size
  Gprintf(money(rules_company[s.num].money), x + offset_rent[s.side].x, y + offset_rent[s.side].y, offset_rent[s.side].w, 'center')
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
      :draw(draw[rules_group[rules_company[i].group].draw])
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
    x, y = get_xy(c, side)
    if side == 1 or side == 3 then
      w = cw
      h = ch
    else
      w = ch
      h = cw
    end
    E:new(companys)
    :set({pos = c, side = side, num = i, mortgage_alpha = 0, all_alpha = 0, x = x, y = y, w = w, h = h, logo_hover = 0})
    :draw(draw[rules_group[rules_company[i].group].draw])
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
  if s.ingame == true then  
    fnt_big:select()
    fnt_big:scale(0.4)
    sx = 30
    player_im1:draw(s.x, s.y, 0, sx)
    S.setColor(rules_player_colors[s.k])
    player_im2:draw(s.x+4, s.y+4, 0, sx-8)
    S.setColor(255,255,255)
    if gamemenu._visible == false then
      S.print(money(s.cash), ch+45, ch+55 + s.k*36)
      --~ rules_player_images[s.k]:draw(ch+10, ch+55 + s.k*36, 0, sx)
      player_im1:draw(ch+10, ch+55 + s.k*36, 0, sx)
      S.setColor(rules_player_colors[s.k])
      player_im2:draw(ch+10+4, ch+55 + s.k*36+4, 0, sx-8)
    end
    if s.k == current_player then
      S.setBlendMode('additive')
      S.setColor(255,255,255,(math.sin(time*7)+1)*90)
      player_im2:draw(s.x+4, s.y+4, 0, sx-8)
      if gamemenu._visible == false then player_im2:draw(ch+10+4, ch+55 + s.k*36+4, 0, sx-8) end
      S.setBlendMode('alpha')
    end
    
    if s.jail > 0 then 
      S.setColor(255,255,255,255)
      player_jail:draw(s.x+2, s.y+2, 0, 26)
    end
  --elseif gamemenu._visible == false then 
    --Gprint('Bankrupt', ch+45, ch+97 + s.k*30)
  end
end

--кости
dice_draw = function(s)
  dice[s.ds1 or 1]:draw(s.x, s.y, 0, 64)
  dice[s.ds2 or 1]:draw(s.x + 66, s.y, 0, 64)
end

dices = E:new(board_gui):draw(dice_draw):move(ch + 10, ch + 10)
gui_text = E:new(board_gui):draw(function(s)
  fnt_big:select()
  fnt_big:scale(14/35)
  Gprintf(s.text, ch + 158, ch + 20, 800 - ch * 2 - 168)
end)
gui_text.text = ''
--анимация передачи денех
local coins = E:new(screen):image('data/gfx/gold_coin_single.png'):size(24,24):hide()
local money_transfer_param = {speed = 1, cb = function(s) s:hide() end}
money_transfer = function(money, from, to)
  --~ if to then 
    --~ from.cash = from.cash - money
    --~ to.cash = to.cash + money
  --~ else
    --~ from.cash = from.cash + money
  --~ end
  local from = players._child[from]
  local to = players._child[to]
  from:delay({speed = 0, cb = function() 
    
    if lquery_fx == true then
      sound_coin:play()
    end
    coins:stop():move(from.x + 3, from.y):show()
    coins.a = 255
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
  --~ if initplayers[current_player] == 'Computer' then player:delay(1) end
end


board:keypress(function( s, key, unicode )
   if key == "f" then 
     lquery_fx = not lquery_fx 
   end
   if key == "1" and iflinux then
      player._child[1].cash = player._child[1].cash - 1000
   end
   if key == "q" and iflinux then
      player._child[1].cash = player._child[1].cash + 100
   end
   if key == "2" and iflinux then
      player._child[2].cash = player._child[2].cash - 1500
   end
   if key == "w" and iflinux then
      player._child[2].cash = player._child[2].cash + 100
   end
   if key == "3" and iflinux then
      player._child[3].cash = player._child[3].cash - 1000
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
end)


--[[
local rag_upd = function(s)
S.setdrawTarget(s.fb)
S.setFont(console)
S.fontSize = 10*screen_scale
S.setColor(255,255,255)
Gprintf('Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.Текстами рефератов можно пользоваться совершенно бесплатно, однако при транслировании и предоставлении текстов в массовое пользование ссылка на Яндекс.Рефераты обязательна.Служба Яндекс.Рефераты предназначена для студентов и школьников, дизайнеров и журналистов, создателей научных заявок и отчетов — для всех, кто относится к тексту, как к количеству знаков.Нажав на кнопку «Написать реферат» вы лично создаете уникальный текст, причем именно от вашего нажатия на кнопку зависит, какой именно текст получится — таким образом, авторские права на реферат принадлежат только вам.Теперь никто не сможет обвинить вас в плагиате, ибо каждый текст Яндекс.Рефератов неповторим.',0,s.oy,s.w*screen_scale)
S.setdrawTarget()
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


frame = E:new(screen):set({x = 300, y = ch, w = 400, h = 600-ch, oy = 0, fb = S.newFramebuffer( 400*screen_scale, (600-ch*2)*screen_scale )})
:draw(function(s)
S.draw(s.fb, s.x, s.y, 0, 1/screen_scale)
end):mousepress(drag_start):mouserelease(drag_end)
rag_upd(frame)
]]
--~ local fupd = loadfile('rules/classic/offsets.lua')
--~ E:new(board_gui):move(200, 400):slider('Cell width', 50, 60, {'cw'}, 
--~ function(v) 
  --~ ch = (800-cw*field_width)/2 
  --~ a = (600-ch*2)/field_height - cw 
  --~ scaley = (ch-sep_padding*2)/16 
  --~ burn:size(800 - ch*2+10,600 - ch*2 +10):move(ch - 5,ch - 5) 
  --~ fupd()
--~ end)
--~ E:new(board_gui):move(200, 440):slider('Cell padding', 0, 10, {'cell_padding'}, fupd)
--~ --E:new(screen):move(300, 250):slider('ch', 20, 200, {'ch'}, function(v) a = (600-ch*2)/field_height - cw print(a) end)