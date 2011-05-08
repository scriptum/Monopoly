-- Экшн для поля налог
nalog = function(player)
 player.money = player.money - 150
end

-- Экшн для поля Компания
company = function(player, self)
 if self.owner then
  if self.level = 1 then
   players[self.owner] = players[self.owner] + money[2]
   cashback(player, self.money[2])
  elseif self.level = 2 then
   players[self.owner].money = players[self.owner] + money[2]*2
   cashback(player, self.money[2]*2)
  elseif self.level > 2 then
   players[self.owner] = players[self.owner] + self.money[level]
   cashback(player, self.money[level])
  end
 else
  buy(player, self)
 end
end

-- покупка компании
buy = function(player, company)
 if cashback(player, company.money[1]) then
  company.owner = player
 end
end

-- Отъем денег
cashback = function(player, money)
 if players[player].money >= money then
  players[player].money = players[player].money - money
  return true
 end
end