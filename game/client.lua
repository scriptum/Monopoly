--запускаем наш "сервер"
S.newThread('game/server.lua')

----------------------------Вспомогательные функции-----------------------------

--трансляция позиции игрока на клетке в координаты на экране, весьма непростая задача
getplayerxy = function(n, k)
  side = companys._child[n].side
  x, y = get_xy(companys._child[n].pos, side)
  if side == 1 then
    x = x + math.cos(k*math.pi)*14 + 8
    y = y + k*12 - 3
  elseif side == 2 then
    x = x + k*14 - 12
    y = y + math.cos(k*math.pi)*12 + 12
  elseif side == 3 then
    x = x + math.cos(k*math.pi)*12 + 8
    y = y + k*12 - 12
  elseif side == 4 then
    x = x + k*14 -15
    y = y + math.cos(k*math.pi)*12 + 12
  else
    x = x + k*14 -15
    y = y + math.cos(k*math.pi*0.5)*30 + 24
  end
  return x + cell_padding, y + cell_padding
end

--бросок кубиков, здесь нужен только для анимации поэтому нет особой рандомизации
local roll = function(a, b)
  dices.ds1 = math.random(1,6)
  dices.ds2 = math.random(1,6)
end

--------------------------Основные действия на клиенте--------------------------

--движение игрока
move = function(num, ds1, ds2)
  local pl = players._child[num]
  current_player = num --это для того, чтобы замигал текущий игрок
  local x = ds1 + ds2
  local i = math.random(1,6)
  sound_dice[i]:play()
  local j = i 
  while i == j do j = math.random(1,6) end
  sound_dice[j]:play()
  --анимация броска кубиков
  for i = 1, 19 do
    pl:delay({speed = i/200, callback = roll})
  end
  --после анимации устанавливаем истинное значние, присланное нам с сервера
  pl:delay({speed = 0.05, callback = function()
	dices.ds1, dices.ds2 = ds1, ds2
  end})
  pl:delay(0.5)
  if pl.jail == 0 then --не знаю, нужно ли на клиенте проверять, сидит ли он в тюрьме? По теории это нужно в сервер
    local pl_x, pl_y
    local last_cell = pl.pos
    local last_i = 1
    --это хитрый цикл, который "прокручивая" всё поле считает кол-во скошенных углов, а на основе кол-ва этих углов формирует траекторию движения игрока
    for i=1, x do
      pl.pos = pl.pos + 1
      if pl.pos > max then
		pl.pos = pl.pos-max
      end
      if table.find(angles, pl.pos) > 0 then
		pl_x, pl_y = getplayerxy(pl.pos, pl.k)
		pl:animate({x=pl_x, y=pl_y},{speed=(i + 1 - last_i)/5})
		last_cell = pl.pos
		last_i = i
      end
    end
    if pl.pos ~= last_cell then
      pl_x, pl_y = getplayerxy(pl.pos, pl.k)
      pl:animate({x=pl_x, y=pl_y},{speed=(x + 1 - last_i)/5})
    end
  end
end

--изменение денег игрока
set_cash = function(num, money)
  local pl = players._child[num]
  pl:delay({speed = 0, cb = function()
    pl:stop('money'):animate({cash = money}, {speed = 0.7, queue = 'money'})
  end})
end

--движение монетки и вообще анимация передачи денег
local coin = E:new(screen):image('data/gfx/gold_coin_single.png'):size(24,24):hide()
local money_transfer_param = {speed = 1, cb = function(s) s:hide() end}
cash_trans = function(money, from, to)
  local pl1 = players._child[from]
  coin:stop():move(pl1.x + 3, pl1.y):show()
  coin.a = 255
  if to then
    local pl2 = players._child[to]
    coin:animate({x = pl2.x + 3, y = pl2.y}, money_transfer_param)
  else
    if money > 0 then
      coin:animate({y = pl1.y - 24, a = 30}, money_transfer_param)
    else
      coin.y = pl1.y - 24
      coin:animate({y = pl1.y, a = 30}, money_transfer_param)
    end
  end
  if lquery_fx == true then
    sound_coin:play()
  end
end

--изменение владельца компании
set_owner = function(company, player)
  rules_company[company].owner = players._child[player]
  companys._child[company]:set({owner_alpha = 0}):animate({owner_alpha = 150})
end

------------------------Подготовительная часть клиента--------------------------

--создаем локальные объекты-плееры
players = E:new(board)
for k = 1, 5 do
  local   x, y = getplayerxy(1, k)
  E:new(players)
  :draw(player_draw):set{k=k, jail=0, pos=1, x=x, y=y, cash = 0}  
end

--добавляем ловушку, функции в ловушке должны быть глобальными, 
--так как их вызов будет происходить в другом месте
local lasttime = 0
lQuery.addhook(function()
	--проверка каждый 20 мс - как раз время накопления стека ТСР
	if time - lasttime > 0.02 then 
		lasttime = time
		--получаем сообщение с кодом "g"
		msg = S.recv('g')
		--только одно сообщение за такт - нужно, чтобы не томозило процесс рендеринга
		if msg then 
			--выполняем полученное сообщение как луа скрипт, игнорируя ошибки
			xpcall(loadstring(msg), print)
			--print(msg)
		end
		
	end
end)
