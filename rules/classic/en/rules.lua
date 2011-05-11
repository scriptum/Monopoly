reason_jail = {
  '����������, ��� �� ����� ��� � �������. ������������� � ������',
  '���������� ������� ���������� ��������� � ���������. ������������� � ������',
  '� ���� ����� �� ������� ���������� �������, ��� ����� ��� � ������. ������������� � ������',
  '���� ���������� �������� ��� ��������, � ��� �������� ��������. ������������� � ������',
}

reason_jail_2 = {
  '���������� ������ ������� ��������� � ��������, ��� �� ����� ��� � �������. ������������� � ������.',
  '����� �� ���� �� ��������� � ������ - ��������� ����� � ��� �������� �����������. ��� ��������.',
  '�� ��������� � ���������� ��������� ������ � � ���-�� ���������. �� ����� ������� ��������� ������ ������������ ��� ����������.',
}

action_phrase = {
  jail = '� ���������� ������ � ��� ��� ������� ���������',
  island = '�� ������������ ��������� �� �������.',
  company_free= '��� �������� ����� �� ������. �� ������ ������ � ��� ��������� �� �������.'
}

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
    draw = "company",
    phrase = {
      '�������� ������� ����������� � ����� ������� ���� �� ������. ��� �������� �������� %',
      '���������� ������ ����, ������ ���� �� ������. ����� �� ����� ���������, ��������� %',
      '������ �� �������� ������������� �������������� ����� ������ ���. �������� ������������� �� %',
      '������ ���� ��������� ����� �� ������ ����� � ���� ����� ����������. ��������� %',
      '���� �� ����� ������ �������, ��� �������������� ���������, ��� �������� �������� ������� � ����: %',
      '��������� �������� �������� ���������� � ����� � ���� �� ������ ����� ����������. ���� ������� ��������� %'
    }
  },
  food = {
    image = "coffee.png", 
    upgrade = 50,
    draw = "company"
  },
  bank = {
    image = "bank.png",
    upgrade = 200,
    draw = "company",
    phrase = {
      '�� ��������� ����������� ���� ��������� � ��������� ���������� ������',
      '�� ���������� ������� �� �������. ��������� �����',
      '�� �� ��������� ������� �� ������� ������ �������. ��������� �����',
      '��������� �������������� �������� ����� ������� � ������ �������',
      '�������� ���������� ������� �����������. �� ������ ������'
    }
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
    draw = "nalog",
    phrase = {
      '���������� ������ ���������. �� �� ������ �������� ���������',
      '������ ����� ������� � ����� ������� � ��������� ���� ��������',
      '� ��� ����� ������ � ���������� � �������. ��������� �����',
      '���� ���������� ����� ���. �������� � ������ ����� ���������',
      '� ��� ������� ������. ����� ���-���� ���� ��� ������...'
    }
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
    group = "big",
    action = action_jail_value
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
    group = "big",
    action = action_island
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
  text = "������� �����\n�������� $ 150 �"
 },

{
type = "chance",
action =  cashback,
money = 100,
text = "�� �������� ��������� �� ��������\n�������� $ 100 �"
},

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "���������� ���������\n�������� $ 50 �"
 },

 {
  type = "chance",
  action = cashback,
  money = -15,
  text = "����� �� ���������� ��������\n��������� $ 15 �"
 },

 {
  type = "chance",
  action = cashback,
  money = -20,
  text = "�������� � ��������� ����\n����� $ 20 �"
 },

 {
  type = "chance",
  action = cashback,
  money = -150,
  text = "������ ������ ���������\n��������� $ 150 �"
 },

 {
  type = "chance",
  action = cashback,
  money = -120,
  text = "�� ����� ������ ��������: \"����� ����\"... �������\n������ �������� � $ 120 �"
 },

 {
  type = "chance",
  action = cashback,
  money = 80,
  text = "��������� ���������� ����� �������\n�������� $ 80 �"
 },

 {
  type = "chance",
  action = cashback,
  money = 3,
  text = "�� ������� �������� � �������� ������\n�������� $ 3 �"
 },

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "�� ����� ������� ����� � ����� ��� � �������. �� �������� ����������� ���� ��� ������\n�������� $ 50 �"
 }
}

--Chest
rules_treasury = {
 {
  type = "treasury",
  action = cashback,
  money = 200,
  text = "���������� ������ � ���� ������\n�������� $ 200 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "�������� ������� �����\n�������� $ 25 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "������ ���������\n��������� $ 50 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "�������� ������� �����\n�������� $ 25 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "���� �����\n�������� $ 100 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "���������� ������\n�������� $ 25 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "�� �������� ����������\n�������� $ 100 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "������ ����� �������\n��������� $ 50 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "������ �������\n��������� $ 100 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = 50,
  text = "�������� ������� ���������\n�������� $ 50 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "�� �������� ��������\n������� $ 50 �"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "����������� ���� ���� ��������� �������� ����� ���� ��������\n��������� $ 100 �"
 }
}

--��������������� �������� �������� � ���������� � ������
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
  table.insert(rules_company_images, G.newImage('rules/classic/en/logos/'..k..'.png'))
end

--��������������� �������� �������� � �������� � ������
rules_group_images = {}
for k, v in pairs(rules_group) do 
  if v.image then
    rules_group_images[k] = G.newImage('rules/classic/icons/'..v.image)
  end
end
