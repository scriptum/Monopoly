G.oldprintf = G.printf
G.fontSize = 10
G.fontSizeOrig = 24
Gprintf = function(text, x, y, limit, align)
  local s = G.fontSize/G.fontSizeOrig
  local s1 = G.fontSizeOrig/G.fontSize
  G.scale(s)
  G.printf(text, math.floor((x or 0)/s), math.floor((y or 0)/s), (limit or 0)/s, align or "left")
  G.scale(s1)
end

Gprint = function(text, x, y)
  local s = G.fontSize/G.fontSizeOrig
  local s1 = G.fontSizeOrig/G.fontSize
  G.scale(s)
  G.print(text, math.floor((x or 0)/s), math.floor((y or 0)/s))
  G.scale(s1)
end