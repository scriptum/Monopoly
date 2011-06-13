--определяем язык
lang = 'en'
if arg[1] then lang = arg[1] end
scrupp.init('Test', 1280, 700, 32, false, false, false)
scrupp.setDelta(2)
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

Fonts['Pt Sans'][8]:select()

--~ table.print(S.stringToLines("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", 500))
--~ E:new(screen):image(FontTextures[2], true):draggable()
--~ E:new(screen):draw(function(s)
	--~ G.setColor(255,255,255)
	--~ Fonts['Pt Sans'][8]:select()
	--~ S.printLines(, 100, 100)
--~ end)
require 'lib/console'

ff = S.newThread("th.lua")
table.insert(lquery_hooks, function()
	local msg = S.recv("2")
	while msg do
		print(msg)
		msg = S.recv("2")
	end
end)