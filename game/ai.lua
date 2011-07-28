-- искусственный интеллект
ai = function(pl)
  local companys = current_game.companys
-- если денег меньше нуля - закладываем компании
  --~ if pl.cash < 0 then
    --~ for k,v in pairs(rules_company) do
      --~ if v.owner == pl and v.level == 1 and mortgage_company(pl, v, k) == true then
	--~ ai(pl)
	--~ return
      --~ end
    --~ end
    --~ for k,v in pairs(rules_company) do
      --~ if mortgage_company(pl, v, k) == true then
	--~ ai(pl)
	--~ return
      --~ end
    --~ end
  --~ end
  --~ -- игрок вылетает
  --~ if pl.cash < 0 then
    --~ for k,v in pairs(rules_company) do
      --~ if v.owner == pl then
	--~ v.owner = nil
	--~ v.level = 1
	--~ companys._child[k].mortgage_alpha = 0
      --~ end
    --~ end
    --~ pl.ingame = false
    --~ pl.pos = 1
--~ --    sound_out:play()
  --~ end

  -- покупка компании

  if rules_company[pl.pos].type == "company" and 
    not companys[pl.pos].owner and 
      pl.cash >= rules_company[pl.pos].money[1] then 
	buy_company(pl.k, pl.pos) --покупка компании на сервере
  end
--~ 
  --~ if not_buy == false and buy_company(pl, pl.pos) == true then
    --~ ai(pl)
    --~ return
  --~ elseif not_buy == false and rules_company[pl.pos].type == "company" and not rules_company[pl.pos].owner then
    --~ auction(pl, pl.pos)
--~ --    player:delay({speed = 0, cb = function() ai(pl) end})
    --~ return
  --~ end
--~ -- прокачка компаний
  --~ for k,v in pairs(rules_company) do
    --~ if v.type == "company" and v.owner == pl and pl.cash >= (rules_group[v.group].upgrade) then
      --~ if buyshares_company(pl, v) == true then
	--~ ai(pl)
	--~ return
      --~ end
    --~ end
  --~ end
  --~ -- выкуп компаний
  --~ for k,v in pairs(rules_company) do
    --~ if v.type == "company" and v.owner == pl and pl.cash >= (v.money[1] + 200) then
      --~ if buyout_company(pl, v, k) == true then
	--~ ai(pl)
	--~ return
      --~ end
    --~ end
  --~ end
  --~ not_buy = false
end