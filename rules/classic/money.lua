--�-� ������� �����
money = function(m)
  if m >= 1000 then
    return '$' .. m/1000 .. 'M'
  else
    return '$' .. m .. 'K'
  end
end