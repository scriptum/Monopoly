--меню для игрока
playermenu = E:new(screen)
menuplayer = E:new(playermenu):menu({
	{text = 'Buy company', action = human_buy_company},
	{text = 'Auction', action = human_auction},
	{text = 'Mortgage', action = function() 
		for k, v in pairs(companys._child) do 
			local c = rules_company[v.num]
			if not(c.owner == player._child[current_player] and c.level > 0) then
			  v:animate({all_alpha = 255}, 0.7)
			end
		end 
		gui_mortgage_done:menutoggle(menuplayer)
	end},
	{text = 'Shares', action = function() 
		for k, v in pairs(companys._child) do 
			local c = rules_company[v.num]
			if not(c.owner == player._child[current_player] and c.level > 1) or (c.group == 'oil' or c.group == 'bank') then
			  v:animate({all_alpha = 255}, 0.7)
			end
		end 
		gui_shares_done:menutoggle(menuplayer)
	end},
	{text = 'Trade', action = function() 
		for k, v in pairs(companys._child) do 
			local c = rules_company[v.num]
			if not(c.owner == player._child[current_player] and c.level == 0) then
			  v:animate({all_alpha = 255}, 0.7)
			end
		end 
		gui_trade_done:menutoggle(menuplayer)
	end}
}):hide()
end_move = E:new(menuplayer):move(272, 120):button('End turn', turn):hide()

game_ower = E:new(menuplayer):move(272, 194):button('Surrender', game_ower):hide()

gui_shares_done = E:new(playermenu):move(272, 194):button('Done', function() 
	gui_shares_done:menutoggle(menuplayer)
	for k, v in pairs(companys._child) do
		v:animate({all_alpha = 0})
	end 
end):hide()

gui_mortgage_done = E:new(playermenu):move(272, 194):button('Done', function() 
	gui_mortgage_done:menutoggle(menuplayer)
	for k, v in pairs(companys._child) do
		v:animate({all_alpha = 0})
	end 
end):hide()

gui_trade_done = E:new(playermenu):move(272, 194):button('Done', function() 
	gui_trade_done:menutoggle(menuplayer)
	for k, v in pairs(companys._child) do
		v:animate({all_alpha = 0})
	end 
end):hide()

gamemenu = E:new(screen):hide()
menuvsettings = E:new(gamemenu):hide()
local modes = G.getModes()
table.sort(modes, function(a, b) return a.width < b.width end)
local dislay_modes = {}
for _, v in pairs(modes) do
	table.insert(dislay_modes, v.width .. 'x' .. v.height)
end

local screenlist = E:new(menuvsettings):move(200, 150):list('Screen resolution', dislay_modes, dislay_modes, {'gameoptions', 'mode'})
local screenmode = E:new(menuvsettings):move(200, 200):list('Screen mode', {true, false}, {'fullscreen', 'windowed'}, {'gameoptions', 'fullscreen'})
local apply = E:new(menuvsettings):move(130, 400):button('Apply', function(s) 
	local p = screenlist._pos
	local mode = G.getWidth() .. 'x' .. G.getHeight()
	local full = screenmode._vars[screenmode._pos]
	if gameoptions.mode ~= mode or gameoptions.fullscreen ~= full then
		gameoptions.fullscreen = full
		G.setMode(modes[p].width, modes[p].height, full)
		screen_scale, x_screen_scale, y_screen_scale = getScale() --rescale screen
	end
end)
E:new(menuvsettings):move(200, 250):slider('Sound volume', 0, 100, {'gameoptions', 'volume'}, function(v)A.setVolume(v/100)end)


local function mainsettings() menumain:menutoggle(menuvsettings) end
local function mainsingle() menumain:menutoggle(menusingle) end
E:new(menuvsettings):move(414, 400):button('Back', mainsettings)

menumain = E:new(gamemenu):menu({
	{text = 'Singleplayer', action = mainsingle},
	{text = 'Multiplayer', action = nil},
	--{text = 'Audio settings', action = nil},
	{text = 'Settings', action = mainsettings},
	{text = 'Quit', action = function() love.event.push('q') end}
})

menusingle = E:new(gamemenu):hide()

local singleplayer_options = {'Human', 'Computer', 'Empty'}
for i = 1, 5 do
	E:new(menusingle):move(200, 100+i*50):list('player', singleplayer_options, singleplayer_options, {'initplayers', i})
	E:new(menusingle):image(rules_player_images[i]):move(280, 100+i*50):scale(40/64, 40/64)
end
E:new(menusingle):move(130, 400):button('Start', new_game)
E:new(menusingle):move(414, 400):button('Back', mainsingle)


