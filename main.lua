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
--~ Entity:new(screen):draw(function(s)
  --~ G.fontSize = 10
  --~ G.setFont(console)
  --~ G.setColor(0,0,0,255)
  --~ Gprint('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y)
--~ end)




small = G.newFont(12)

local _old_print = print

--Override print and call super
_G["print"] = function(...)
	_old_print(...)
	local str = ""
	local args = {...}
	for i,v in pairs(args) do
		str = str .. tostring(v)
		if i < #args then
			str = str .. "       "
		end
	end
	table.insert(debug_screen.lines, str)
end

debug_oldkeypressed = love.keypressed
debug_oldkeyreleased = love.keyreleased
debug_keypressed = function(key, unicode)
  local s = debug_screen
  if key == "`" or key == "escape" then
  elseif key =="return" then
    table.insert(s.lines, '> ' .. s.input)
    xpcall(loadstring(s.input), 'Error!')
    s.input = ""
    s.cursor = 0
  elseif key == "left" then
		s.cursor = s.cursor - 1
		if s.cursor < 0 then s.cursor = 0 end
  elseif key == "home" then
    s.cursor = 0
  elseif key == "end" then
    s.cursor = s.input:len()
	elseif key == "right" then
		s.cursor = s.cursor + 1
		if s.cursor > s.input:len() then
			s.cursor = s.input:len()
		end
  elseif key == "backspace" then 
    if s.cursor > 0 then
      s.input = s.input:sub(1, s.cursor - 1) .. s.input:sub(s.cursor + 1, s.input:len())
      s.cursor = s.cursor - 1
    end
  elseif key == "delete" then 
    if s.cursor < string.len(s.input) then
      s.input = s.input:sub(1, s.cursor) .. s.input:sub(s.cursor + 2, s.input:len())
    end
  elseif key:len() == 1 then 
    if unicode ~= nil and unicode ~= 0 then
      local char = string.char(unicode)
      if s.cursor == s.input:len() then
        s.input = s.input .. char
      else
        s.input = s.input:sub(1, s.cursor) .. char .. s.input:sub(s.cursor + 1, s.input:len())
      end
      s.cursor = s.cursor + 1
    end
  end
end
debug_screen = E:new()
:size(800, 200)
:move(0, 627)
:set({lines = {}, input = "", cursor = 0, disabled = true, history = {}})
:draw(function(s)
  G.setColor(0,0,0,190)
  G.rectangle("fill", s.x, s.y, s.w, s.h)
  G.rectangle("fill", s.x+720, s.y - 25, s.w - 720, 26)
  G.setColor(0,0,0,255)
  G.rectangle("line", s.x, s.y, s.w, s.h)
  G.rectangle("line", s.x+720, s.y - 25, s.w - 720, 26)
  G.fontSize = 24 / screen_scale
  G.setFont(small)
  G.setColor(255,255,255,255)
  G.line(s.x, s.y + 186, s.w, s.y + 186)
  Gprintf('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(),s.x,s.y - 24,s.w, "right")
  Gprintf('> ' .. s.input,s.x,s.y + 188,s.w)
  if math.sin(time*6) > 0 then
    Gprint('|', (small:getWidth('> ') + small:getWidth(string.sub(s.input, 0, s.cursor)) - 2) / screen_scale, s.y + 188)
  end
  local c, i = 0, 0
  for i = math.max(#s.lines - 14, 1), #s.lines do
    Gprint(s.lines[i], s.x, s.y + c * 12)
    c = c + 1
  end
end)