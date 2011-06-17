print('server')
require 'rules.classic.ru.rules' --загружаются правила
require 'rules.classic.action' --тут размер поля, экшны
local S = scrupp
local send = S.send
local delay = S.delay
local players = {} --на сервере свои плееры
--читсло клеток всего
local cell_count = field_width * 2 + field_height * 2 + 4

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

local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	delay(20) --не тормозим комп
end