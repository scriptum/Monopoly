-- ������������� ���������
ai = function(pl)
-- ���� ����� ������ ���� - ����������� ��������
  if pl.cash < 0 then
    for k,v in pairs(rules_company) do
      if v.owner == pl and v.level == 1 and mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
    for k,v in pairs(rules_company) do
      if mortgage_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  -- ����� ��������
  player:delay({speed = 0, cb = function()
    if pl.cash < 0 then
      for k,v in pairs(rules_company) do
	if v.owner == pl then
	  v.owner = nil
	  v.level = 1
	  companys._child[k].mortgage_alpha = 0
	end
      end
      pl.ingame = false
      pl.pos = 1
      sound_out:play()
    end
  end})
  -- ������� ��������
  if not_buy == false and buy_company(pl, pl.pos) == true then
    player:delay({speed = 0, cb = function() ai(pl) end})
    return
  elseif not_buy == false and rules_company[pl.pos].type == "company" and not rules_company[pl.pos].owner then
    auction(pl, pl.pos)
--    player:delay({speed = 0, cb = function() ai(pl) end})
    return
  end
-- �������� ��������
  for k,v in pairs(rules_company) do
    if v.type == "company" and v.owner == pl and pl.cash >= (rules_group[v.group].upgrade) then
      if buyshares_company(pl, v) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  -- ����� ��������
  for k,v in pairs(rules_company) do
    if v.type == "company" and v.owner == pl and pl.cash >= (v.money[1] + 200) then
      if buyout_company(pl, v, k) == true then
	player:delay({speed = 0, cb = function() ai(pl) end})
	return
      end
    end
  end
  not_buy = false
  player:delay({callback=gogo})
end