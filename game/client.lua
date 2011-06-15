S.newThread('game/server.lua')
print('client')
local lasttime = 0
table.insert(lquery_hooks, function()
	--проверка каждый 20 мс - как раз время накопления стека ТСР
	if time - lasttime > 0.02 then 
		lasttime = time
		--получаем сообщение с кодом "g"
		msg = S.recv('g')
		--только одно сообщение за такт - нужно, чтобы не томозило процесс рендеринга
		if msg then
			pcall(loadstring(msg))
		end
		
	end
end)