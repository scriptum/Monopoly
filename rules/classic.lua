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

-- ���� ������� ��������
action_company = function(player)
 local level = rules_company[player.pos].level
 local money = rules_company[player.pos].money
 local cell = rules_company[player.pos]
 local cash
 if cell.owner and cell.owner ~= player and level > 0 then
  if level == 1 then
   cash = money[2]
  elseif level == 2 then
   cash = money[2] * 2
  else
   cash = money[level]
  end  
  money_transfer(cash, player, cell.owner)
 end
end

-- �����
action_nalog = function(player)
  money_transfer(-rules_company[player.pos].money, player)
end

-- ��� �������� ��������
action_oil = function(player)
 local level = rules_company[player.pos].level
 local money = rules_company[player.pos].money
 local cell = rules_company[player.pos]
 local cash
 if cell.owner and cell.owner ~= player and level > 0 then
  if level == 3 then
   cash = money[2]
  else
   cash = money[2] * 2 ^ (level - 3)
  end
--  print("pay from oil: "..cash)
  money_transfer(cash, player, cell.owner)
 end
end

-- ��� ���������� ��������
action_bank = function(player)
 local level = rules_company[player.pos].level
 local money = rules_company[player.pos].money
 local cell = rules_company[player.pos]
 local cash
 if cell.owner and cell.owner ~= player and level > 0 then
  if level == 3 then
   cash = (ds1 + ds2) * money[2]
  else
   cash = (ds1 + ds2) * money[3]
  end
--  print("pay from bank: "..cash)
  money_transfer(cash, player, cell.owner)
 end
end

-- ���� �������
action_jail = function(pl)
  pl.pos = 13
  pl.jail = 4
  local x, y = getplayerxy(13, pl.k)
  pl:animate({x=x}, {speed=0.5}):animate({y=y}, {speed=0.5})
  player:delay(1)
  if lquery_fx == true then A.play(sound_jail) end
end

-- ���� ������
action_jail_value = function(player)
 if player.jail == 0  and math.random(1, 5) == 1 then action_jail(player) end
end

-- ��� �����
cashback_chance = function(player)
 math.randomseed(os.time() + time + math.random(99999))
 local chance = math.random(1, #rules_chance)
 money_transfer(rules_chance[chance].money, player)
-- print("Chance: "..rules_chance[chance].money)
end

-- ��� �����
cashback_treasury = function(player)
 math.randomseed(os.time() + time + math.random(99999))
 local treasury = math.random(1, #rules_treasury)
 money_transfer(rules_treasury[treasury].money, player)
-- print("Treasury: "..rules_chance[treasury].money)
end

--������, ���� ������ �������� ��� ��������� ��� � ������ ������ ������ ����
rules_group =
{
  auto = {
    image = "dashboard.png", --��������-������ ��� ������ (����� ���� ����)
    upgrade = 150,           --��������� �������� ����� ��� ���� ������
    draw = "company"    --������� ���������� ������ ���� ������
  },
  oil = {
    image = "drop.png",
    upgrade = 200,
    draw = "company"
  },
  food = {
    image = "coffee.png", 
    upgrade = 50,
    draw = "company"
  },
  bank = {
    image = "bank.png",
    upgrade = 200,
    draw = "company"
  },
  inet = {
    image = "web.png",
    upgrade = 50,
    draw = "company"
  },
  market = {
    image = "shopping_cart.png",
    upgrade = 100,
    draw = "company"
  },
  it = {
    image = "computer.png",
    upgrade = 150,
    draw = "company"
  },
  mobile = {
    image = "mobile.png",
    upgrade = 100,
    draw = "company"
  },
  sport = {
    image = "medal.png",
    upgrade = 100,
    draw = "company"
  },
  clock = {
    image = "clock.png",
    upgrade = 150,
    draw = "company"
  },
  chance = {
    image = nil,
    draw = "chance"
  },
  treasury = {
    image = nil,
    draw = "chance"
  },
  nalog = {
    image = nil,
    draw = "nalog"
  },
  big = {
    draw = "big_cell"
  }
}

--������ ������ � ����������, ������, ������, �������, ��������, ������� � ���������

rules_company =
{
  {
    name = "Start",
    type = "big",
    group = "big"
  },

  {
    name = "McDonald's",                    --�������� ��������
    type = "company",                       --��� (��� ��� ��������)
    group = "food",                         --������ - ���������
    money = {60, 2, 10, 30, 90, 160, 250},  --����: ���������, �����: ��� �����, � 1,2,3,4,5 �������
    action = action_company
  },

  {
    name = "Shell",
    type = "company",
    group = "oil",
    money = {200, 50},
    action = action_oil
  },

  {
    name = "Danone",
    type = "company",
    group = "food",
    money = {60, 2, 10, 30, 90, 160, 250},
    action = action_company
  },

  {
    name = "Coca-Cola",
    type = "company",
    group = "food",
    money = {80, 4, 20, 60, 180, 320, 450},
    action = action_company
  },

  {
    name = "Chest",
    group = "treasury",
    action = cashback_treasury
  },

  {
    name = "Bank of America",
    type = "company",
    group = "bank",
    money = {150, 7, 20},
    action = action_bank
  },

  {
    name = "Chance",
    group = "chance",
    action = cashback_chance
  },

  {
    name = "Yahoo!",
    type = "company",
    group = "inet",
    money = {100, 6, 30, 90, 270, 400, 550},
    action = action_company
  },

  {
    name = "Yandex",
    type = "company",
    group = "inet",
    money = {100, 6, 30, 90, 270, 400, 550},
    action = action_company
  },

  {
    name = "Chevron",
    type = "company",
    group = "oil",
    money = {200, 50},
    action = action_oil
  },

  {
    name = "Google",
    type = "company",
    group = "inet",
    money = {120, 8, 40, 100, 300, 450, 600},
    action = action_company
  },
  
  {
    name = "Jail",
    type = "big",
    group = "big"
--    action = action_jail_value
  },
  
  {
    name = "Leroy Merlin",
    type = "company",
    group = "market",
    money = {140, 10, 50, 150, 450, 625, 750},
    action = action_company
  },

  {
    name = "Auchan",
    type = "company",
    group = "market",
    money = {140, 10, 50, 150, 450, 625, 750},
    action = action_company
  },

  {
    name = "AT&T",
    type = "company",
    group = "mobile",
    money = {180, 14, 70, 200, 550, 750, 950},
    action = action_company
  },

  {
    name = "Tax",
    group = "nalog",
    money = 150,
    action = action_nalog
  },

  {
    name = "Vodafone",
    type = "company",
    group = "mobile",
    money = {180, 14, 70, 200, 550, 750, 950},
    action = action_company
  },

  {
    name = "Beeline",
    type = "company",
    group = "mobile",
    money = {200, 16, 80, 220, 600, 800, 1000},
    action = action_company
  },

  {
    name = "Island",
    type = "big",
    group = "big"
  },



  {
    name = "Puma",
    type = "company",
    group = "sport",
    money = {220, 18, 90, 250, 700, 825, 1050},
    action = action_company
  },
  
  {
    name = "BP",
    type = "company",
    group = "oil",
    money = {200, 50},
    action = action_oil
  },

  {
    name = "Nike",
    type = "company",
    group = "sport",
    money = {220, 18, 90, 250, 700, 825, 1050},
    action = action_company
  },


  {
    name = "Adidas",
    type = "company",
    group = "sport",
    money = {240, 20, 100, 300, 750, 925, 1100},
    action = action_company
  },

  {
    name = "Chest",
    group = "treasury",
    action = cashback_treasury
  },

  {
    name = "Citigroup",
    type = "company",
    group = "bank",
    money = {150, 7, 20},
    action = action_bank
  },

  {
    name = "Chance",
    group = "chance",
    action = cashback_chance
  },

  {
    name = "Ford",
    type = "company",
    group = "auto",
    money = {260, 22, 110, 330, 800, 975, 1150},
    action = action_company
  },

  {
    name = "Nissan",
    type = "company",
    group = "auto",
    money = {260, 22, 110, 330, 800, 975, 1150},
    action = action_company
  },

  {
    name = "ExonMobil",
    type = "company",
    group = "oil",
    money = {200, 50},
    action = action_oil
  },

  {
    name = "Hyundai",
    type = "company",
    group = "auto",
    money = {280, 24, 120, 360, 850, 1150, 1200},
    action = action_company
  },

  {
    name = "Customs",
    type = "big",
    group = "big",
    action = action_jail
  },

  {
    name = "Omega",
    type = "company",
    group = "clock",
    money = {320, 28, 150, 450, 1000, 1200, 1400},
    action = action_company
  },

  {
    name = "Rolex",
    type = "company",
    group = "clock",
    money = {320, 28, 150, 450, 1000, 1200, 1400},
    action = action_company
  },

  {
    name = "IBM",
    type = "company",
    group = "it",
    money = {350, 35, 175, 500, 1100, 1300, 1500},
    action = action_company
  },

  {
    name = "Tax",
    group = "nalog",
    money = 150,
    action = action_nalog
  },

  {
    name = "Intel",
    type = "company",
    group = "it",
    money = {350, 35, 175, 500, 1100, 1300, 1500},
    action = action_company
  },

  {
    name = "Apple",
    type = "company",
    image = "Apple-logo.png",
    group = "it",
    money = {400, 50, 200, 600, 1400, 1700, 2000},
    action = action_company
  }
}


-- ��������
rules_chance = {
 {
  type = "chance",
  action = cashback,
  money = 150,
  text = "������� �����\n�������� 150�"
 },

{
type = "chance",
action =  cashback,
money = 100,
text = "�� �������� ��������� �� ��������\n�������� 100�"
},

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "���������� ���������\n�������� 50�"
 },

 {
  type = "chance",
  action = cashback,
  money = -15,
  text = "����� �� ���������� ��������\n��������� 15�"
 },

 {
  type = "chance",
  action = cashback,
  money = -20,
  text = "�������� � ��������� ����\n����� 20�"
 },

 {
  type = "chance",
  action = cashback,
  money = -150,
  text = "������ ������ ���������\n��������� 150�"
 }
}

--Chest
rules_treasury = {
 {
  type = "treasury",
  action = cashback,
  money = 200,
  text = "���������� ������ � ���� ������\n�������� 200�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "�������� ������� �����\n�������� 25�"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "������ ���������\n��������� 50�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "�������� ������� �����\n�������� 25�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "���� �����\n�������� 100�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "���������� ������\n�������� 25�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "�� �������� ����������\n�������� 100�"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "������ ����� �������\n��������� 50�"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "������ �������\n��������� 100�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 50,
  text = "�������� ������� ���������\n�������� 50�"
 },

 {
  type = "treasury",
  action = cashback,
  money = 10,
  text = "�� ������ ������ ����� �� �������� �������\n�������� 10�"
 }
}

--��������������� �������� �������� � ���������� � ������
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
  table.insert(rules_company_images, G.newImage('data/gfx/eng/'..k..'.png'))
end

--��������������� �������� �������� � �������� � ������
rules_group_images = {}
for k, v in pairs(rules_group) do 
  if v.image then
    rules_group_images[k] = G.newImage('data/gfx/blue_icons/'..v.image)
  end
end
--��������������� �������� �������� � �������� � ������
rules_player_images = {}
for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, G.newImage('data/gfx/player/'..v))
end