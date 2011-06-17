--запускаем наш "сервер"
S.newThread('game/server.lua')
print('client')
local lasttime = 0

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

move = function(num, x)
  pl = player._child[num]
  if pl.jail == 0 then
    local pl_x, pl_y
    local last_cell = pl.pos
    local last_i = 1
    -- добавляем все углы, по которым проходим
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

player = E:new(board)

for k = 1, 5 do
  E:new(player)
  :draw(player_draw):set{k=k, jail=0, pos=1}  
end

table.insert(lquery_hooks, function()
	--проверка каждый 20 мс - как раз время накопления стека ТСР
	if time - lasttime > 0.02 then 
		lasttime = time
		--получаем сообщение с кодом "g"
		msg = S.recv('g')
		--только одно сообщение за такт - нужно, чтобы не томозило процесс рендеринга
		if msg then 
			--выполняем полученное сообщение как луа скрипт, игнорируя ошибки
			xpcall(loadstring(msg), print)
		end
		
	end
end)