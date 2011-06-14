getScale = function()
  local aspect = S.getWidth()/S.getHeight()
  local s = 1
  local x = 0
  local y = 0
  if(aspect > 4/3) then
    s = S.getHeight()/600
    x = math.floor((S.getWidth()-800*s)/2)
  else
    s = S.getWidth()/800
    y = math.floor((S.getHeight()-600*s)/2)
  end
  return s, x, y
end

screen_scale, x_screen_scale, y_screen_scale = getScale()
screen:draw(function()
  --screen_scale, x_screen_scale, y_screen_scale = getScale()
  S.translate(x_screen_scale, y_screen_scale)
  S.scale(screen_scale)
  
end)
fnt_small = Fonts["Liberation Sans bold"][8]
fnt_big = Fonts["PT Sans Caption"][35]
getMouseXY = function()
  local x, y = S.getMousePos()
  return (x - x_screen_scale)/screen_scale, (y - y_screen_scale)/screen_scale
end

--Entity:new(screen):image(board_background):set({sx = 800/1024, sy = 600/1024})


--~ floorquad = love.graphics.newQuad(0, 0, 800, 600, board_background:getWidth(), board_background:getHeight())
--~ board_background:setWrap("repeat", "repeat")

Entity:new(screen):image(board_background):set({w=800,h=600})

--~ console = G.newImageFont('data/gfx/font.png', " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#$=[]\"àáâãäå¸æçèéêëìíîïğñòóôõö÷øùúûüışÿÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕ×ÖØÙÚÛÜİŞß")

--~ small = G.newFont('data/fonts/ru.ttf',14)