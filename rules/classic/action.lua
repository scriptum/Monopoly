field_width = 11 --�������� �� �����������
field_height = 6 --�������� �� ���������
cell_jail = 13 --�� ����� ������ ������
--�������� ��� �������
rules_player_img = {
	'player_blue.png',
	'player_green.png',
	'player_red.png',
	'player_sea.png',
	'player_yellow.png'
}

rules_player_colors = {
	{0,0,255},
	{0,255,0},
	{255,0,0},
	{0,255,255},
	{255,255,0}
}

local rnd_txt = function(a, s)
  if s and a then 
    gui_text.text = a[math.random(1, #a)]:gsub('%%', money(s))
  elseif a then
    gui_text.text = a[math.random(1, #a)]
  end
end
-- ����� ���� ��������
__action_company = function(player, f)
	local level = rules_company[player.pos].level
	local money = rules_company[player.pos].money
	local cell = rules_company[player.pos]
	if cell.owner then 
		if cell.owner == player then
			gui_text.text = action_phrase.company_my
		elseif level > 0 then
			f(level, money, cell)
		else
		  gui_text.text = action_phrase.company_mortgage
		end
	else
		gui_text.text = action_phrase.company_free
	end
end

-- ���� ������� ��������
action_company = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 1 then
	    cash = money[2]
    elseif level == 2 then
	    cash = money[2] * 2
    else
	    cash = money[level]
    end  
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group[cell.group].phrase, cash)
  end)
end

-- �����
action_nalog = function(player)
  local m = rules_company[player.pos].money
  money_transfer(-m, player)
  rnd_txt(rules_group.nalog.phrase, m)
end

-- ��� �������� ��������
action_oil = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 3 then
	    cash = money[2]
    else
	    cash = money[2] * 2 ^ (level - 3)
    end
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group.oil.phrase, cash)
  end)
end

-- ��� ���������� ��������
action_bank = function(player)
  __action_company (player, function(level, money, cell)
    local cash
    if level == 3 then
	    cash = (ds1 + ds2) * money[2]
    else
	    cash = (ds1 + ds2) * money[3]
    end
    money_transfer(cash, player, cell.owner)
    rnd_txt(rules_group.bank.phrase, cash)
  end)
end

-- ���� �������
action_jail = function(pl)
  pl.pos = 13
  pl.jail = 4
  local x, y = getplayerxy(13, pl.k)
  pl:animate({x=x}, {speed=0.5}):animate({y=y}, {speed=0.5})
  player:delay(1)
  if lquery_fx == true then A.play(sound_jail) end
  rnd_txt(reason_jail)
end

-- ���� ������
action_jail_value = function(player)
  if player.jail == 0 and math.random(1, 5) == 1 then 
    action_jail(player)
    rnd_txt(reason_jail_2)
  elseif player.jail == 0 then
    gui_text.text = action_phrase.jail
  end
end

-- ���� �����
cashback_chance = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local chance = math.random(1, #rules_chance)
	gui_text.text = '����: ' .. rules_chance[chance].text
	money_transfer(rules_chance[chance].money, player)
-- print("Chance: "..rules_chance[chance].money)
end

-- ���� �����
cashback_treasury = function(player)
	math.randomseed(os.time() + time + math.random(99999))
	local treasury = math.random(1, #rules_treasury)
	gui_text.text = '�����: ' .. rules_treasury[treasury].text
	money_transfer(rules_treasury[treasury].money, player)
-- print("Treasury: "..rules_chance[treasury].money)
end

-- ���� �������
action_island = function(player)
	gui_text.text = action_phrase.island
end

--��������������� �������� �������� � �������� � ������
rules_player_images = {}
for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, G.newImage('data/gfx/player/'..v))
end

--�����
action = G.newImage('rules/classic/icons/document.png')
all_actions = G.newImage('rules/classic/icons/briefcase.png')