print('server')
require 'rules.classic.ru.rules' --загружаются правила
local S = scrupp
local send = S.send
local delay = S.delay
local players = {} --на сервере свои плееры
for i = 1, 5 do
	table.insert(players, {
		pos = 1, 
		jail = 0, 
		ingame = false, 
		cash = 1500, 
		name = "", --имя
		address = "", --айпишник (ну в теории он будет)
		uid = 0 --серверу нужно будет как-то понять, от какого игрока пришло сообщение
	})
end
send('start_new_game() menumain:hide()', 'g') -- запуск игры
local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	delay(20) --не тормозим комп
end