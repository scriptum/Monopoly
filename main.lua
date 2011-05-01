loadscreen = love.graphics.newImage('data/gfx/load.jpg')
love.graphics.draw(love.graphics.newImage('data/gfx/load.jpg'), 0, 0, 0, love.graphics:getWidth()/1024, love.graphics:getHeight()/1024)
love.graphics.present()
require('lib.lquery')
require('lib.ui')
require('lib.ui.button')
require('lib.ui.list')
require('lib.ui.slider')
require('lib.ui.menu')
require('lib.serialize')
require('lib.sound')
--require('lib.scale')
require('rules.classic')
require('data')
require('game')
Entity:new(screen):draw(function(s)
  G.fontSize = 10
  G.setFont(console)
  G.setColor(0,0,0,255)
  Gprint('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y)
end)






