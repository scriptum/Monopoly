G.oldprintf = G.printf
G.fontSize = 10
G.fontSizeOrig = 32
Gprintf = function(text, x, y, limit, align)
  local s = G.fontSize/G.fontSizeOrig
  local s1 = G.fontSizeOrig/G.fontSize
  G.scale(s, s)
  G.printf(text, (x or 0)/s, (y or 0)/s, (limit or 0)/s, align or "left")
  G.scale(s1, s1)
end

Gprint = function(text, x, y)
  local s = G.fontSize/G.fontSizeOrig
  local s1 = G.fontSizeOrig/G.fontSize
  G.scale(s, s)
  G.print(text, (x or 0)/s, (y or 0)/s)
  G.scale(s1, s1)
end