reason_jail = {
  'It turned out that you have long wanted. Go to jail',
  'Customs officers discovered violation in invoices. Go to jail',
}

reason_jail_2 = {
  'When you were on excursion in jail employee found in you a dangerous criminal. Stay in jail',
}

action_phrase = {
  jail = 'Jail stuff have no claims to you',
  island = 'You are staying at the resort',
  company_free= 'This company is free. You can buy it or put it on auction',
  company_my= 'This is your company',
  company_mortgage= 'This is mortgaged company, you don\'t pay anything',
}

rules_players_names = {'Blue', 'Green', 'Red', 'Azure', 'Yellow'}

--группы, одна группа означает как монополию так и просто клетки одного типа
rules_group =
{
  auto = {
    image = "dashboard.dds", --image of the group
    upgrade = 150,           --upgrade cost
    draw = "company",        --render function
    phrase = {               --phrases to display
      'You have an accident. You had to buy a new car for %',
      'The hurricane destroyed the car factory, causing a rise in prices. Expenses %',
    }
  },
  oil = {
    image = "drop.dds",
    upgrade = 200,
    draw = "company",
    phrase = {
      'An accident at an oil field sparked a new rise in prices. Expenses %',
    }
  },
  food = {
    image = "coffee.dds", 
    upgrade = 50,
    draw = "company",
    phrase = {
      'The waiter politely asked for a tip, you could not refuse. Had to give him a tip %',
    }
  },
  bank = {
    image = "bank.dds",
    upgrade = 200,
    draw = "company",
    phrase = {
      'You did not read the terms of the credit in small print. Pay %',
    }
  },
  inet = {
    image = "web.dds",
    upgrade = 50,
    draw = "company",
    phrase = {
      'Your server is down. Need to buy new for %',
    }
  },
  market = {
    image = "shopping_cart.dds",
    upgrade = 100,
    draw = "company",
    phrase = {
      'In the shop manager persuaded you to buy a lot of unnecessary things for %',
    }
  },
  it = {
    image = "computer.dds",
    upgrade = 150,
    draw = "company",
    phrase = {
      'There was a new copyright law. You need to buy software for %',
    }
  },
  mobile = {
    image = "mobile.dds",
    upgrade = 100,
    draw = "company",
    phrase = {
      'You talked on the phone to Antarctica. Pay %',
    }
  },
  sport = {
    image = "medal.dds",
    upgrade = 100,
    draw = "company",
    phrase = {
      'Your favorite sports team lost. Costs of the broken TV - %',
    }
  },
  clock = {
    image = "clock.dds",
    upgrade = 150,
    draw = "company",
    phrase = {
      'Your watch is broken. Had to buy new for %',
    }
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
      'Pay tax %',
    }
  },
  big = {
    draw = "big_cell"
  }
}

--list of companies

rules_company =
{
  {
    name = "Start",
    type = "big",
    group = "big"
  },

  {
    name = "McDonald's",                    --company name
    type = "company",                       --type
    group = "food",                         --group - monopoly
    money = {60, 2, 10, 30, 90, 160, 250},  --costs: prise, rent: without actions (houses), with 1,2,3,4,5 actions
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
    name = "Chance",
    group = "chance",
    action = cashback_chance
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
    name = "Chest",
    group = "treasury",
    action = cashback_treasury
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
    money = 200,
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
    group = "it",
    money = {400, 50, 200, 600, 1400, 1700, 2000},
    action = action_company
  }
}


-- Карточки
rules_chance = {
 {
  type = "chance",
  action = cashback,
  money = 150,
  text = "Loan repayment\get $ 150 К"
 },

{
type = "chance",
action =  cashback,
money = 100,
text = "You won the Chess Championship\nget $ 100 К"
},

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "Bank dividends\nget $ 50 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -15,
  text = "Penalty for speeding\npay $ 15 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -20,
  text = "Drunk driving\npay $ 20 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -150,
  text = "Payment of drivers courses\npay $ 150 К"
 },

 {
  type = "chance",
  action = cashback,
  money = 80,
  text = "Lottery ticket won\nget $ 80 К"
 },

 {
  type = "chance",
  action = cashback,
  money = 3,
  text = "You worked hard and were awarded\nget $ 3 К"
 },
}

--Chest
rules_treasury = {
 {
  type = "treasury",
  action = cashback,
  money = 200,
  text = "Bank error in your favor\nget $ 200 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "Profitable sale of shares\nget $ 25 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "Payment of insurance\npay $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "Collecting rent\nget $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "Tax Refund\nget $ 25 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "You received an inheritance\nget $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "Payment for the services of doctor\npay $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "Payment for treatment\npay $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 50,
  text = "Profitable sale of bonds\nget $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "You lost wallet\nlost $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "Your credit card take kids to play\npay $ 100 К"
 }
}

