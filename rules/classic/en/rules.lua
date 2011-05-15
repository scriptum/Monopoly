reason_jail = {
  'Выяснилось, что вы давно уже в розыске. Отправляйтесь в тюрьму',
  'Сотрудники таможни обнаружили нарушения в накладных. Отправляйтесь в тюрьму',
  'В пылу спора вы ударили сотрудника таможни, чем ввели его в ярость. Отправляйтесь в тюрьму',
  'Ваши конкуренты устроили вам подставу, и вас признали виновным. Отправляйтесь в тюрьму',
}

reason_jail_2 = {
  'Сотрудники тюрьмы сверяли документы и выяснили, что вы давно уже в розыске. Отправляйтесь в тюрьму.',
  'Когда вы были на экскурсии в тюрьме - сотрудник узнал в Вас опасного приступника. Вас посадили.',
  'Вы ввалились в незнакомое помещение пьяным и с кем-то подрались. За такую наглось начальник тюрьмы распорядился вас арестовать.',
  'Вы заключили пари с друзьями, что прикольнетесь над полицейским. Сидя в тюрьме, вы начали смутно догадываться, что шутка не совсем удалась.'
}

action_phrase = {
  jail = 'У работников тюрьмы к вам нет никаких претензий',
  island = 'Вы остановились отдохнуть на курорте.',
  company_free= 'Эта компания никем не занята. Вы можете купить её или выставить на аукцион.',
  company_my= 'Это ваша компания, вы ничего не теряете.',
  company_mortgage= 'Это заложенная компания, вы не терпите никаких расходов.',
}

rules_players_names = {'Синий', 'Зеленый', 'Красный', 'Голубой', 'Жёлтый'}

--группы, одна группа означает как монополию так и просто клетки одного типа
rules_group =
{
  auto = {
    image = "dashboard.png", --картинка-иконка для группы (может быть цвет)
    upgrade = 150,           --стоимость апгрейда акций для этой группы
    draw = "company",        --функция рендеринга клеток этой группы
    phrase = {               --список фраз, которые пишутся при попадании на группу (выбирается случайно)
      'Вы просрочили страховку и попали в аварию. Пришлось покупать новую машину за %',
      'Ураган уничтожил автозавод, что вызвало рост цен. Расходы %',
      'У вас угнали машину. Через неделю ее нашли сгоревшей в канаве. Пришлось купить новую за %',
      'Вандалы разбили стелко машины и вытащили магнитолу. Присмотревшись, вы поняли, что и колеса, и двери, и сидения, и все, что было в багажнике, и даже все, что было под капотом. Ремонт обошелся в %'
    }
  },
  oil = {
    image = "drop.png",
    upgrade = 200,
    draw = "company",
    phrase = {
      'Нефтяные магнаты сговорились и снова подняли цены на бензин. Вам пришлось выложить %',
      'НЕОЖИДАННО пришла зима, власти были не готовы. Спрос на мазут подскочил, заплатите %',
      'Авария на нефтяном месторождении спровоцировала новый скачок цен. Придется раскошелиться на %',
      'Страны ОПЕК уменьшили квоту на добычу нефти и цены резко подскочили. Заплатите %',
      'Цены на нефть растут быстрее, чем прогнозировали аналитики, вам пришлось уплатить разницу в цене: %',
      'Президент нефтяной компании проигрался в карты и цены на бензин резко подскочили. Ваши расходы составили %'
    }
  },
  food = {
    image = "coffee.png", 
    upgrade = 50,
    draw = "company",
    phrase = {
      'За пьяный дебош, устроенный в ресторане с вас вычли %',
      'Официант вежливо попросил на чай, вы не смогли отказать. Пришлось оставить ему %',
      'Вы хотели улизнуть из ресторана, не заплатив, но не тут-то было. Уладить отношения с секьюрити стоило вам %',
      'Вышел закон, по которому мясные продукты теперь должны содержать мясо. Цены подскачили. Расходы составили %'
    }
  },
  bank = {
    image = "bank.png",
    upgrade = 200,
    draw = "company",
    phrase = {
      'На заседании центробанка было объявлено о повышении процентных ставок. Ваши убытки составили %',
      'Вы просрочили платежи по кредиту. Заплатите штраф %',
      'Вы не прочитали условия по кредиту мелким шрифтом. Заплатите штраф %',
      'Неудачная инвестиционная политика банка привела к потере средств в размере %',
      'Долговые банковские векселя анулированы. Вы несете убытки в размере %'
    }
  },
  inet = {
    image = "web.png",
    upgrade = 50,
    draw = "company",
    phrase = {
      'Упал сервер. С верхней полки. Пришлось менять на новый стоимостью %',
      'Майкрософт снова судится с поисковыми компаниями и поиск стал платным. Счет в %',
      'Когда вам срочно понадобился интернет - его, как обычно, не оказалось. покупка запасного спутникового канала обошлась в %'
    }
  },
  market = {
    image = "shopping_cart.png",
    upgrade = 100,
    draw = "company",
    phrase = {
      'В магазине назойливый менеджер-таки всучил вам кучу ненужных вещей на %',
      'Вы оставили на кассе % и сказали: без сдачи!',
      'Выходя из магазина вы задумались, зачем вам пожизненный набор зубочисток за %? Все-таки замечательные там продавцы, решили вы.',
      'Поход с женой за новыми туфлями обернулся покупкой еще и сумочки, и костюма, и вечернего плвтья на сумму %'
    }
  },
  it = {
    image = "computer.png",
    upgrade = 150,
    draw = "company",
    phrase = {
      'Вирусная эпидемия накрыла все компьтеры у вас в офисе. За востановление данных содрали %',
      'Вышел закон об авторских правах на ПО. Пришлось купить пакет лицензионных программ за %',
      'Во время игры в самый неподходящий момент у вас заглючила мышка... Счет за разбитую мышку, а так же клавиатуру, монитор и системный блок составил %'
    }
  },
  mobile = {
    image = "mobile.png",
    upgrade = 100,
    draw = "company",
    phrase = {
      'Вам пришла СМС от мамы: Срочно положи % на этот номер. Вы заплатили не мешкая.',
      'Вы случайно позвонили во Владивосток. Пока вы выясняли, кто на другом конце провода, счет вырос до %',
      'Вы купили своему ребенку его первый мобильный телефон. В скоре вам пришел счет за мобильные услуги в размере %',
      'Случайно попав на неприличный сайт, вы подхватили вирус, который требовал отправить смс на номер. Отправив смс, ваш счет вырос на %'
    }
  },
  sport = {
    image = "medal.png",
    upgrade = 100,
    draw = "company",
    phrase = {
      'Ваша любимая спортивная команда проиграла. Стоимость разбитого телевизора - %',
      'Вы зашли в магазин спорттоваров за удочкой, однако вас уговорили ещё купить лодку за %',
      'В коем-то веке вы зашли в спортзал потягать штангу. И не рассчитали своих сил. Лечение составило %'
    }
  },
  clock = {
    image = "clock.png",
    upgrade = 150,
    draw = "company",
    phrase = {
      'У ваших золотых часов сломалась секундная стрелка. Установка новой обошлась в %',
      'Часы, купленные вами за % в метро, оказались позолоченными, а на второй день и вовсе сломались.',
      'Вы прочитали в интернете, что у часов оказывается должны быть стрелки. Теперь понятно, в чем заключалась проблема. Пришлось купить новые за %'
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
      'Неожиданно пришла налоговая. Вы не успели спрятать документы. заплатите штраф %',
      'Друзья много болтали о ваших успехах и налоговая тоже услышала. Пришлось дать взятку %',
      'У вас нашли ошибки в декларации о налогах. Заплатите штраф %',
      'Ваши конкуренты сдали вас. Проверки и обыски нашли нарушения. Заплатите штраф %',
      'С вас требуют взятку. Лучше все-таки дать эту взятку... Заплатите %'
    }
  },
  big = {
    draw = "big_cell"
  }
}

--список клеток с компаниями, шансом, казной, стартом, таможней, тюрьмой и парковкой

rules_company =
{
  {
    name = "Start",
    type = "big",
    group = "big"
  },

  {
    name = "McDonald's",                    --название компании
    type = "company",                       --тип (это под вопросом)
    group = "food",                         --группа - монополия
    money = {60, 2, 10, 30, 90, 160, 250},  --цены: стоимость, доход: без акций, с 1,2,3,4,5 акциями
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


-- Карточки
rules_chance = {
 {
  type = "chance",
  action = cashback,
  money = 150,
  text = "Возврат займа\nполучите $ 150 К"
 },

{
type = "chance",
action =  cashback,
money = 100,
text = "Вы выиграли чемпионат по шахматам\nполучите $ 100 К"
},

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "Банковские дивиденты\nполучите $ 50 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -15,
  text = "Штраф за превышение скорости\nзаплатите $ 15 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -20,
  text = "Вождение в нетрезвом виде\nштраф $ 20 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -150,
  text = "Оплата курсов водителей\nзаплатите $ 150 К"
 },

 {
  type = "chance",
  action = cashback,
  money = -120,
  text = "На вашей машине написали: \"ПАМОЙ МИНЯ\"... гвоздем\nремонт обошелся в $ 120 К"
 },

 {
  type = "chance",
  action = cashback,
  money = 80,
  text = "Найденный лотерейный билет выиграл\nполучите $ 80 К"
 },

 {
  type = "chance",
  action = cashback,
  money = 3,
  text = "Вы усердно работали и получили премию\nполучите $ 3 К"
 },

 {
  type = "chance",
  action = cashback,
  money = 50,
  text = "Вы нашли чемодан денег и сдали его в милицию. На радостях милиционеры дали вам премию\nполучите $ 50 К"
 }
}

--Chest
rules_treasury = {
 {
  type = "treasury",
  action = cashback,
  money = 200,
  text = "Банковская ошибка в вашу пользу\nполучите $ 200 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "Выгодная продажа акций\nполучите $ 25 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "Оплата страховки\nзаплатите $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "Выгодная продажа акций\nполучите $ 25 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "Сбор ренты\nполучите $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 25,
  text = "Возмещение налога\nполучите $ 25 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 100,
  text = "Вы получили наследство\nполучите $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "Оплата услуг доктора\nзаплатите $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "Оплата лечения\nзаплатите $ 100 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = 50,
  text = "Выгодная продажа облигаций\nполучите $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -50,
  text = "Вы потеряли бумажник\nпропало $ 50 К"
 },

 {
  type = "treasury",
  action = cashback,
  money = -100,
  text = "Оставленную вами дома кредитную карточку взяли дети поиграть\nзаплатите $ 100 К"
 }
}

--предварительная загрузка картинок с компаниями в память
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
  table.insert(rules_company_images, G.newImage('rules/classic/'..lang..'/logos/'..k..'.png'))
end

--предварительная загрузка картинок с группами в память
rules_group_images = {}
for k, v in pairs(rules_group) do 
  if v.image then
    rules_group_images[k] = G.newImage('rules/classic/icons/'..v.image)
  end
end
