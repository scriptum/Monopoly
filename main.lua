require('lquery')
require('ui')
require('ui.list')
require('ui.menu')
require('rules.classic')
require('data')
require('game')
text = Entity:new(screen):draw(function(s)
  G.fontSize = 10
  G.setFont(console)
  G.setColor(0,0,0,255)
  Gprint('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y)
end)




