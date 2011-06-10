--определяем язык
lang = 'en'
if arg[1] then lang = arg[1] end
scrupp.init('Test', 1280, 960, 32, false, false, false)
scrupp.setDelta(0)
require('lib')
require('game.start')
--~ loadscreen = love.graphics.newImage('data/gfx/load.png')
--~ love.graphics.draw(loadscreen, 0, 0, 0, love.graphics:getWidth()/loadscreen:getWidth(), love.graphics:getHeight()/loadscreen:getHeight())
--~ love.graphics.present()
require('lib.ui')
require('lib.ui.button')
require('lib.ui.list')
require('lib.ui.slider')
require('lib.ui.menu')
require('lib.sound')
require('languages.'..lang)
--require('lib.scale')
require('rules.classic.action')
require('rules.classic.'..lang..'.rules')

require('data')
require('game')

--~ E:new(screen):image(FontTextures[2], true):draggable()

require 'lib/console'