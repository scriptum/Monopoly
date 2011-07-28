--ф-я формата денег
money = function(m)
  if not m then m = 0 end
  if m >= 1000 then
    return '$' .. math.floor(m)/1000 .. 'M'
  else
    return '$' .. math.floor(m) .. 'K'
  end
end
--сколько давать бабла за прохождение старта
money_add = 200