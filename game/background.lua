local getScale = function()
  local aspect = G.getWidth()/G.getHeight()
  local s = 1
  local x = 0
  local y = 0
  if(aspect > 4/3) then
    s = G.getHeight()/600
    x = math.floor((G.getWidth()/s-800)/2)
  else
    s = G.getWidth()/800
    y = math.floor((G.getHeight()/s-600)/2)
  end
  return s, x, y
end
screen_scale, x_screen_scale, y_screen_scale = getScale()
screen:draw(function()
  --screen_scale, x_screen_scale, y_screen_scale = getScale()
  G.scale(screen_scale)
  G.translate(x_screen_scale, y_screen_scale)
end)

getMouseXY = function()
  return love.mouse.getX()/screen_scale - x_screen_scale, love.mouse.getY()/screen_scale - y_screen_scale
end

Entity:new(screen):image(board_background):set({sx = 800/1024, sy = 600/1024})

console = G.newImageFont('data/gfx/font.png', " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#$=[]\"àáâãäå¸æçèéêëìíîïğñòóôõö÷øùúûüışÿÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕ×ÖØÙÚÛÜİŞß")
