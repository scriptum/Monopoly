--определяем язык
lang = 'en'
if arg[1] then lang = arg[1] end
scrupp.init('Test', 800, 600, 32, false, false, false)
scrupp.setDelta(0)
require('lib')

require('game.start')
--~ loadscreen = love.graphics.newImage('data/gfx/load.png')
--~ love.graphics.draw(loadscreen, 0, 0, 0, love.graphics:getWidth()/loadscreen:getWidth(), love.graphics:getHeight()/loadscreen:getHeight())
--~ love.graphics.present()
require('ui')
require('lib.ui.button')
require('lib.ui.list')
require('lib.ui.slider')
require('lib.ui.menu')
require('lib.sound')
require('languages.'..lang)
--require('lib.scale')
require('rules.classic.action')
require('rules.classic.images')
require('rules.classic.'..lang..'.rules')
require('rules.classic.'..lang..'.images')

require('data')
require('game')



--~ E:new(screen):image(FontTextures[2], true):draggable()
--~ E:new(screen):draw(function(s)
	--~ G.setColor(255,255,255)
	--~ Fonts['Pt Sans'][8]:select()
	--~ S.printLines(S.stringToLines("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500Os, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", 500), 100, 100)
--~ end)
require 'console'

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