G.oldprintf = G.printf
G.fontSize = 10
G.fontSizeOrig = 32
Gprintf = function(text, x, y, limit, align)
  local s = 1/screen_scale
  local s1 = screen_scale
  G.scale(s)
  G.printf(text, math.floor((x or 0)/s), math.floor((y or 0)/s), (limit or 0)/s, align or "left")
  G.scale(s1)
end

Gprint = function(text, x, y)
  local s = 1/screen_scale
  local s1 = screen_scale
  G.scale(s)
  G.print(text, math.floor((x or 0)/s), math.floor((y or 0)/s))
  G.scale(s1)
end