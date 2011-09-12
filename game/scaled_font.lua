--~ G.oldprintf = G.printf

Gprint = function(text, x, y, limit, align)
  local s = 1/screen_scale
  S.scale(s)
  if fnt_small == fnt_big then fnt_big:scale(9/35*screen_scale) end
  S.print(text, math.floor((x or 0)/s), math.floor((y or 0)/s), (limit or 0)/s, align)
  S.scale(screen_scale)
end

Gprintf = function(text, x, y, limit, align)
  local s = 1/screen_scale
  S.scale(s)
  if fnt_small == fnt_big then fnt_big:scale(9/35*screen_scale) end
  --~ S.setLineWidth(3)
  --~ S.rectangle(math.floor((x or 0)/s), math.floor((y or 0)/s), limit/s,limit/s)
  S.printf(text, math.floor((x or 0)/s), math.floor((y or 0)/s), (limit or 0)/s, align)
  S.scale(screen_scale)
end