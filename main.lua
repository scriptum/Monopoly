--определяем язык
lang = 'en'
if arg[2] then lang = arg[2] end
require('lib.lquery')
require('lib.serialize')
require('game.start')
loadscreen = love.graphics.newImage('data/gfx/load.png')
love.graphics.draw(loadscreen, 0, 0, 0, love.graphics:getWidth()/loadscreen:getWidth(), love.graphics:getHeight()/loadscreen:getHeight())
love.graphics.present()
require('lib.ui')
require('lib.ui.button')
require('lib.ui.list')
require('lib.ui.slider')
require('lib.ui.menu')
require('lib.sound')
print(lang)
require('languages.'..lang)
--require('lib.scale')
require('rules.classic.action')
require('rules.classic.'..lang..'.rules')

require('data')
require('game')
Entity:new(screen):draw(function(s)
  G.fontSize = 10
  G.setFont(console)
  G.setColor(0,0,0,255)
  Gprint('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y)
end)






