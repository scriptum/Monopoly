print('server')
require 'rules.classic.ru.rules' --загружаются правила
require 'rules.classic.action' --тут размер поля, экшны
local S = scrupp
local send = S.send
local delay = S.delay
local players = {} --на сервере свои плееры
local i
local cell_count = field_width * 2 + field_height * 2
angles = {1, field_width + 2, field_width + field_height + 3, field_width * 2 + field_height + 4}

send('max = '..cell_count, 'g')
send('angles = {1, '..field_width..' + 2, '..field_width..' + '..field_height..' + 3, '..field_width..' * 2 + '..field_height..' + 4}', 'g')

--создаем игроков
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
	send('player._child['..i..'].ingame = true move('..i..', 1)', 'g')
end
--читсло клеток всего

local companys = {}
for i = 1, cell_count do
	table.insert(companys, {})
end
--send('start_new_game() menumain:hide()', 'g') -- запуск игры
local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	delay(20) --не тормозим комп
end