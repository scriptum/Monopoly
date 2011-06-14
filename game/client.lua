S.newThread('game/server.lua')
print('client')
table.insert(lquery_hooks, function()
	msg = S.recv("game")
	if msg then
		
	end
end)