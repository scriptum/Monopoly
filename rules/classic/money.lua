--ф-я формата денег
money = function(m)
  if not m then m = 0 end
  if m >= 1000 then
    return '$' .. m/1000 .. 'M'
  else
    return '$' .. m .. 'K'
  end
end