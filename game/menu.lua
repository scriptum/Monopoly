--меню для игрока
playermenu = E:new(screen)
menuplayer = E:new(playermenu):hide()

E:new(menuplayer):move(126, 360):button(l.buy_company, human_buy_company)
E:new(menuplayer):move(418, 360):button(l.auction, human_auction)

E:new(menuplayer):size(128, 32):move(126, 450):button(l.mortgage, human_mortgage)
E:new(menuplayer):size(128, 32):move(266, 450):button(l.unmortgage, human_unmortgage)
E:new(menuplayer):size(128, 32):move(406, 450):button(l.shares, human_shares)
E:new(menuplayer):size(128, 32):move(546, 450):button(l.trade, nil)

end_move = E:new(menuplayer):move(126, 360):button(l.end_turn, turn):hide()
game_ower = E:new(menuplayer):move(418, 360):button(l.surrender, game_ower):hide()
gui_pay50k = E:new(menuplayer):move(418, 360):button(l.pay_50_K, pay50k):hide()

gui_shares_done = E:new(playermenu):move(272, 360):button(l.done, human_shares_done):hide()
gui_mortgage_done = E:new(playermenu):move(272, 360):button(l.done, human_mortgage_done):hide()
gui_unmortgage_done = E:new(playermenu):move(272, 360):button(l.done, human_unmortgage_done):hide()


manuauction = E:new(playermenu):hide()
gui_auction_text = E:new(manuauction):text('$ 100 K', 30):move(126, 375)
local w, h, sx = 91, 32, 280
E:new(manuauction):size(w, h):move(sx, 360):button('+1', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx, 400):button('-1', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx+(w+10), 360):button('+10', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx+(w+10), 400):button('-10', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx+(w+10)*2, 360):button('+100', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx+(w+10)*2, 400):button('-100', click_manuauction_button)
E:new(manuauction):size(w, h):move(sx+(w+10)*3, 360):button('Bid', click_manuauction_button_bid):set({disabled = true})
E:new(manuauction):size(w, h):move(sx+(w+10)*3, 400):button('Pass', click_manuauction_button_pass)

gamemenu = E:new(screen):hide()
menuvsettings = E:new(gamemenu):hide()

--меню игры
local modes = G.getModes()
table.sort(modes, function(a, b) return a.width < b.width end)
local dislay_modes = {}
for _, v in pairs(modes) do
	table.insert(dislay_modes, v.width .. 'x' .. v.height)
end

local screenlist = E:new(menuvsettings):move(200, 150):list(l.screen_resolution, dislay_modes, dislay_modes, {'gameoptions', 'mode'})
local screenmode = E:new(menuvsettings):move(200, 200):list(l.screen_mode, {true, false}, {l.fullscreen, l.windowed}, {'gameoptions', 'fullscreen'})
local apply = E:new(menuvsettings):move(130, 400):button(l.apply, function(s) 
	local p = screenlist._pos
	local mode = G.getWidth() .. 'x' .. G.getHeight()
	local full = screenmode._vars[screenmode._pos]
	if gameoptions.mode ~= mode or gameoptions.fullscreen ~= full then
		gameoptions.fullscreen = full
		G.setMode(modes[p].width, modes[p].height, full)
		screen_scale, x_screen_scale, y_screen_scale = getScale() --rescale screen
	end
end)
E:new(menuvsettings):move(200, 250):slider(l.sound_volume, 0, 100, {'gameoptions', 'volume'}, function(v)A.setVolume(v/100)end)


local function mainsettings() menumain:menutoggle(menuvsettings) end
local function mainsingle() menumain:menutoggle(menusingle) end
E:new(menuvsettings):move(414, 400):button(l.back, mainsettings)

menumain = E:new(gamemenu):menu({
	{text = l.singleplayer, action = mainsingle},
	{text = l.multiplayer, action = nil},
	--{text = 'Audio settings', action = nil},
	{text = l.settings, action = mainsettings},
	{text = l.quit, action = function() love.event.push('q') end}
})

menusingle = E:new(gamemenu):hide()

local singleplayer_options = {l.human, l.computer, l.empty}
for i = 1, 5 do
	E:new(menusingle):move(200, 100+i*50):list(l.player, singleplayer_options, singleplayer_options, {'initplayers', i})
	E:new(menusingle):image(rules_player_images[i]):move(280, 100+i*50):scale(40/64, 40/64)
end
E:new(menusingle):move(130, 400):button(l.start, new_game)
E:new(menusingle):move(414, 400):button(l.back, mainsingle)


