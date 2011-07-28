print('server')
require 'rules.classic.ru.rules' --загружаются правила
require 'rules.classic.action' --тут размер поля, экшны
require 'game.ai' --искусственный интеллект
require 'game.actions' --действия игрока
local S = scrupp
local send = function ()
  S.send(msg, 'g')
  msg = ''
end
local delay = S.delay



--текущие игры
local games = {}
games['newgame'] = {}
current_game = games['newgame']

current_game.players = {} --на сервере свои плееры
--читсло клеток всего
local cell_count = field_width * 2 + field_height * 2 + 4

local roll = function()
  local ds1, ds2 = 0
  math.randomseed(os.time() + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + math.random(99999))
  ds2 = math.random(1, 6)
  return ds1, ds2
end

msg = 'max = '..cell_count .. ' angles = {1, '..field_width..' + 2, '..field_width..' + '..field_height..' + 3, '..field_width..' * 2 + '..field_height..' + 4}'
send()

msg_add = function(...)
  for k, v in ipairs(arg) do
    if k == 1 then 
      msg = msg .. ' ' .. v .. '('
    else
      if type(v)  == 'string' then v = "'" .. v .. "'" end
      if k == 2 then
	msg = msg .. v
      else
	msg = msg .. ',' .. v
      end
    end
  end
  msg = msg .. ')'
end

--создаем игроков
local i
for i = 1, 2 do
	table.insert(current_game.players, {
		k = i,
		pos = 1, 
		jail = 0, 
		ingame = true, 
		cash = 1500, 
		name = "", --имя
		address = "", --айпишник (ну в теории он будет)
		uid = 0 --серверу нужно будет как-то понять, от какого игрока пришло сообщение
	})
	msg = msg .. ' players._child['..i..'].ingame = true'
	msg_add('set_cash', i, 1500)
end
send(msg, 'g')

--создаем массив компаний
current_game.companys = {}
for i = 1, cell_count do
	table.insert(current_game.companys, {level = 1})
end

current_game.double = 1 --число выкинутых дублей в этой игре
current_game.current_player = 1 --текущий плеер
local __max = 5 --максимально возможное число игроков на сервере

--*******************************************GO-GO*******************************************--

gogo = function()
  local __i = current_game.current_player --текущий игрок
  local buf = current_game.players[__i]
  if not buf or buf.ingame == false or (buf.jail == 4 and current_game.double > 1) then 
    double = 1
    current_game.current_player = __i + 1
    if current_game.current_player > __max then current_game.current_player = 1 end
    gogo()
  else
    local ds1, ds2 = roll() --бросаем кубики
    local add_money = false
    --если игрок прошел старт - добавить ему бабла
    buf.pos = buf.pos + ds1 + ds2
    if buf.pos > cell_count then
      buf.pos = buf.pos - cell_count
      add_money = true
      
    end
    --движение игрока и анимация кубиков на клиентах
    msg_add('move',__i,ds1,ds2)
    send()
    --пауза пока идет анимация
    delay((ds1+ds2)*200 + 2000)
    if add_money == true then
      buf.cash = buf.cash + 200 --добавляем бабла на серверной части
      msg_add('set_cash',__i,buf.cash) --отправляем новое состояние счёта клиентам
    end
    ai(buf)
--    msg = msg .. ' set_cash('..__i..','..math.random(0,1500)..')'
--    msg = msg .. ' money_transfer('..math.random(-15,15)..','..__i..')'
    send()
    
    current_game.current_player = __i + 1
    if current_game.current_player > __max then current_game.current_player = 1 end
  end  
end

local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	gogo()
	delay(20) --не тормозим комп
end