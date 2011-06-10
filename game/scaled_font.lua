--~ G.oldprintf = G.printf
G.fontSize = 10
G.fontSizeOrig = 24
Gprintf = function(text, x, y, limit, align)
  local s = 1/screen_scale
  S.scale(s)
  
  S.print(text, math.floor((x or 0)/s), math.floor((y or 0)/s), (limit or 0)/s, align)
  S.scale(screen_scale)
end

Gprint = Gprintf