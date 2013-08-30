require 'lib.cheetah'
require 'lib.lquery.init'

--определяем язык
lang = 'en'
if arg[1] then lang = arg[1] end

local C = cheetah
--enable windows resizing and disable autoscale to avoid font corruption
C.init('Monopoly game', '800x600 vsync resizable resloader')

require('game.start')
--~ loadscreen = love.graphics.newImage('data/gfx/load.png')
--~ love.graphics.draw(loadscreen, 0, 0, 0, love.graphics:getWidth()/loadscreen:getWidth(), love.graphics:getHeight()/loadscreen:getHeight())
--~ love.graphics.present()
require 'ui.init'
require 'ui.button'
require 'ui.list'
require 'ui.slider'
require 'ui.menu'
-- require 'lib.sound')
require('languages.'..lang)

--require('lib.scale')
require('rules.classic.action')
require('rules.classic.images')
require('rules.classic.'..lang..'.rules')
require('rules.classic.'..lang..'.images')

require('data.init')
require('game.init')


-- require 'lib.console'

--table.print(S.getModes())
--~ S.newThread("th.lua")
--~ table.insert(lquery_hooks, function()
	--~ local msg = S.recv("2")
	--~ if msg then
		--~ print(msg)
	--~ end
	--~ local msg = S.recv("img")
	--~ if msg then
		--~ E:new(screen):image(S.imageFromString(msg)):draggable():animate({x=200,y=300})
	--~ end
--~ end)
cheetah.mainLoop()
