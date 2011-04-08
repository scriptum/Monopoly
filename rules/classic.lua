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
  player.cash = player.cash - cash
  cell.owner.cash = cell.owner.cash + cash
  coins:move(player.x, player.y):show():animate({x = cell.owner.x, y = cell.owner.y}, {speed = 1, callback=function(s) s:hide() end})
 end
end

-- �����
action_nalog = function(player)
player.cash = player.cash - rules_company[player.pos].money
end

-- ��� �������� ��������
action_oil = function(player)
 local level = rules_company[player.pos].level
 local money = rules_company[player.pos].money
 local cell = rules_company[player.pos]
 local cash
 if cell.owner and cell.owner ~= player and level > 0 then
  if level == 1 then
   cash = 25
  else
   cash = 25 * 2 ^ (level - 2)
  end
  player.cash = player.cash - cash
  cell.owner.cash = cell.owner.cash + cash
 end
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
    image = "start.png",
    group = "big"
  },

  {
    name = "McDonald's",                    --�������� ��������
    type = "company",                       --��� (��� ��� ��������)
    image = "mcdonalds-logo.png",           --�������� ����
    group = "food",                         --������ - ���������
    money = {60, 2, 10, 30, 90, 160, 250},  --����: ���������, �����: ��� �����, � 1,2,3,4,5 �������
    action = action_company
  },

  {
    name = "Shell",
    type = "company",
    image = "Shell.png",
    group = "oil",
    money = {200},
    action = action_oil
  },

  {
    name = "Danone",
    type = "company",
    image = "danone.png",
    group = "food",
    money = {60, 2, 10, 30, 90, 160, 250},
    action = action_company
  },

  {
    name = "Coca-Cola",
    type = "company",
    image = "cocacola.png",
    group = "food",
    money = {80, 4, 20, 60, 180, 320, 450},
    action = action_company
  },

  {
    name = "�����",
    group = "treasury",
    image = "treasury.png"
  },

  {
    name = "��������",
    type = "company",
    image = "logo_sberbank.png",
    group = "bank",
    money = {150},
    
  },

  {
    name = "����",
    group = "chance",
    image = "vopros.png"
  },

  {
    name = "Yahoo!",
    type = "company",
    image = "YahooLogo.png",
    group = "inet",
    money = {100, 6, 30, 90, 270, 400, 550},
    action = action_company
  },

  {
    name = "Yandex",
    type = "company",
    image = "yandex.png",
    group = "inet",
    money = {100, 6, 30, 90, 270, 400, 550},
    action = action_company
  },

  {
    name = "������",
    type = "company",
    image = "lukoil.png",
    group = "oil",
    money = {200},
    action = action_oil
  },

  {
    name = "Google",
    type = "company",
    image = "google-logo.png",
    group = "inet",
    money = {120, 8, 40, 100, 300, 450, 600},
    action = action_company
  },
  
  {
    name = "Jail",
    type = "big",
    image = "jail.png",
    group = "big"
  },
  
  {
    name = "Leroy Merlin",
    type = "company",
    image = "logo-leroy-merlin.png",
    group = "market",
    money = {140, 10, 50, 150, 450, 625, 750},
    action = action_company
  },

  {
    name = "����",
    type = "company",
    image = "logo-auchan.png",
    group = "market",
    money = {140, 10, 50, 150, 450, 625, 750},
    action = action_company
  },

  {
    name = "�������",
    type = "company",
    image = "megafon.png",
    group = "mobile",
    money = {180, 14, 70, 200, 550, 750, 950},
    action = action_company
  },

  {
    name = "�����",
    group = "nalog",
    image = "vopros.png",
    money = 150,
    action = action_nalog
  },

  {
    name = "������",
    type = "company",
    image = "Beeline.png",
    group = "mobile",
    money = {180, 14, 70, 200, 550, 750, 950},
    action = action_company
  },

  {
    name = "���",
    type = "company",
    image = "mts.png",
    group = "mobile",
    money = {200, 16, 80, 220, 600, 800, 1000},
    action = action_company
  },

  {
    name = "Island",
    type = "big",
    image = "island.png",
    group = "big"
  },



  {
    name = "Puma",
    type = "company",
    image = "Puma-logo.png",
    group = "sport",
    money = {220, 18, 90, 250, 700, 825, 1050},
    action = action_company
  },
  
  {
    name = "BP",
    type = "company",
    image = "BP_Logo.png",
    group = "oil",
    money = {200},
    action = action_oil
  },

  {
    name = "Nike",
    type = "company",
    image = "nike.png",
    group = "sport",
    money = {220, 18, 90, 250, 700, 825, 1050},
    action = action_company
  },


  {
    name = "Adidas",
    type = "company",
    image = "adidas.png",
    group = "sport",
    money = {240, 20, 100, 300, 750, 925, 1100},
    action = action_company
  },

  {
    name = "�����",
    group = "treasury",
    image = "treasury.png"
  },

  {
    name = "���",
    type = "company",
    image = "vtb_logo.png",
    group = "bank",
    money = {150},
    
  },

  {
    name = "����",
    group = "chance",
    image = "vopros.png"
  },

  {
    name = "Ford",
    type = "company",
    image = "Ford_logo.png",
    group = "auto",
    money = {260, 22, 110, 330, 800, 975, 1150},
    action = action_company
  },

  {
    name = "Nissan",
    type = "company",
    image = "Nissan_logo.png",
    group = "auto",
    money = {260, 22, 110, 330, 800, 975, 1150},
    action = action_company
  },

  {
    name = "��������",
    type = "company",
    image = "logo-tatneft.png",
    group = "oil",
    money = {200},
    action = action_oil
  },

  {
    name = "Hyundai",
    type = "company",
    image = "hyundai.png",
    group = "auto",
    money = {280, 24, 120, 360, 850, 1150, 1200},
    action = action_company
  },

  {
    name = "Customs",
    type = "big",
    image = "customs.png",
    group = "big"
  },

  {
    name = "Omega",
    type = "company",
    image = "Omega.png",
    group = "clock",
    money = {320, 28, 150, 450, 100, 1200, 1400},
    action = action_company
  },

  {
    name = "Rolex",
    type = "company",
    image = "Rolex_logo.png",
    group = "clock",
    money = {320, 28, 150, 450, 100, 1200, 1400},
    action = action_company
  },

  {
    name = "IBM",
    type = "company",
    image = "ibm_logo.png",
    group = "it",
    money = {350, 35, 175, 500, 1100, 1300, 1500},
    action = action_company
  },

  {
    name = "�����",
    group = "nalog",
    image = "vopros.png",
    money = 150,
    action = action_nalog
  },

  {
    name = "Intel",
    type = "company",
    image = "Intel-logo.png",
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

--�����
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
  table.insert(rules_company_images, G.newImage('data/gfx/logos/'..v.image))
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