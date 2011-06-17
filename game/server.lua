print('server')
require 'rules.classic.ru.rules' --загружаются правила
require 'rules.classic.action' --тут размер поля, экшны
local S = scrupp
local send = S.send
local delay = S.delay
local players = {} --на сервере свои плееры
--читсло клеток всего
local cell_count = field_width * 2 + field_height * 2 + 4
local __i = 1

local roll = function()
  local ds1, ds2 = 0
  math.randomseed(os.time() + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + math.random(99999))
  ds2 = math.random(1, 6)
  return ds1, ds2
end

send('max = '..cell_count .. ' angles = {1, '..field_width..' + 2, '..field_width..' + '..field_height..' + 3, '..field_width..' * 2 + '..field_height..' + 4}', 'g')

local msg = ''
--создаем игроков
local i
for i = 1, 5 do
	table.insert(players, {
		pos = 1, 
		jail = 0, 
		ingame = true, 
		cash = 1500, 
		name = "", --имя
		address = "", --айпишник (ну в теории он будет)
		uid = 0 --серверу нужно будет как-то понять, от какого игрока пришло сообщение
	})
	msg = msg .. 'player._child['..i..'].ingame = true '
end
send(msg, 'g')


local companys = {}
for i = 1, cell_count do
	table.insert(companys, {})
end

local gogo = function()
  delay(500)
  local buf = players[__i]
  if players[__i].ingame == true then
    local ds1, ds2 = roll()
    send('move('..__i..', '..ds1+ds2..')', 'g')
  end
  __i = __i + 1
  if __i > #players then __i = 1 end
end

local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	gogo()
	delay(20) --не тормозим комп
end