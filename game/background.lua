local getScale = function()
  local aspect = G.getWidth()/G.getHeight()
  local s = 1
  local x = 0
  local y = 0
  if(aspect > 4/3) then
    s = G.getHeight()/600
    x = (G.getWidth()/s-800)/2
  else
    s = G.getWidth()/800
    y = (G.getHeight()/s-600)/2
  end
  return s, x, y
end

screen:draw(function()
  local s, x, y = getScale()
  G.scale(s,s)
  G.translate(x, y)
end)

getMouseXY = function()
  local s, x, y = getScale()
  return love.mouse.getX()/s - x, love.mouse.getY()/s - y
end

Entity:new(screen):image(board_background)

console = G.newFont('data/fonts/ru.ttf', 32)