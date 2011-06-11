getScale = function()
  local aspect = S.getWidth()/S.getHeight()
  local s = 1
  local x = 0
  local y = 0
  if(aspect > 4/3) then
    s = S.getHeight()/600
    x = math.floor((S.getWidth()/s-800)/2)
  else
    s = S.getWidth()/800
    y = math.floor((S.getHeight()/s-600)/2)
  end
  return s, x, y
end

screen_scale, x_screen_scale, y_screen_scale = getScale()

screen:draw(function()
  --screen_scale, x_screen_scale, y_screen_scale = getScale()
  S.scale(screen_scale)
  S.translate(x_screen_scale, y_screen_scale)
end)
fnt_small = Fonts["Liberation Sans bold"][12]
fnt_big = Fonts["PT Sans Caption"][35]
getMouseXY = function()
  return S.getMouseX()/screen_scale - x_screen_scale, S.getMouseY()/screen_scale - y_screen_scale
end

--Entity:new(screen):image(board_background):set({sx = 800/1024, sy = 600/1024})


--~ floorquad = love.graphics.newQuad(0, 0, 800, 600, board_background:getWidth(), board_background:getHeight())
--~ board_background:setWrap("repeat", "repeat")

Entity:new(screen):image(board_background):set({w=800,h=600,tw=512,th=512})

--~ console = G.newImageFont('data/gfx/font.png', " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#$=[]\"àáâãäå¸æçèéêëìíîïğñòóôõö÷øùúûüışÿÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕ×ÖØÙÚÛÜİŞß")

--~ small = G.newFont('data/fonts/ru.ttf',14)