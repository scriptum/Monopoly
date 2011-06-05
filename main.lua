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



function table.findindex(arr, needle)
  local i = 1, m
  local l = needle:len()
  for m = 1, 3 do
    for k, v in pairs(arr) do 
      --print(k)
      if string.sub(k, 1, l) == needle then 
        if i == debug_screen.tabindex then
          debug_screen.tabindex = debug_screen.tabindex + 1
          return k, v
        else
          i = i + 1
        end
      end
    end
    if debug_screen.tabindex == 1 then 
      break
    else
      debug_screen.tabindex = 1
      i = 1
    end
  end
  
  return nil, nil
end

debug_oldkeypressed = love.keypressed
debug_oldkeyreleased = love.keyreleased
debug_keypressed = function(key, unicode)
  local s = debug_screen
  if key == "`" or key == "escape" then
  elseif key =="return" then
    table.insert(s.lines, '> ' .. s.input)
    if s.history_cursor == #s.history and s.input:len() > 0 then table.insert(s.history, "") end
    s.history_cursor = #s.history
    xpcall(loadstring(s.input), print)
    s.input = ""
    s.cursor = 0
    s.tabindex = 1
  elseif key == "left" then
		s.cursor = s.cursor - 1
		if s.cursor < 0 then s.cursor = 0 end
    s.tabindex = 1
  elseif key == "up" then
    s.history_cursor = s.history_cursor - 1
    if s.history_cursor < 1 then s.history_cursor = 1 end
    s.input = s.history[s.history_cursor]
    s.cursor = s.input:len()
    s.tabindex = 1
  elseif key == "down" then 
    s.history_cursor = s.history_cursor + 1
    if s.history_cursor > #s.history then s.history_cursor = #s.history end
    s.input = s.history[s.history_cursor]
    s.cursor = s.input:len()
    s.tabindex = 1
  elseif key == "home" then
    s.cursor = 0
    s.tabindex = 1
  elseif key == "end" then
    s.cursor = s.input:len()
    s.tabindex = 1
  elseif key == "tab" then 
    local needle = s.tabstr:gsub(".*[ {(\[=+*/#-]", "")
    local arr = _G
    local buf = needle:split2("[.]")
    local k, v
    table.print(buf)
    for k,v in ipairs(buf or {}) do
      if k + 0 == #buf then
        needle = v
      else
        if arr[v] then
          arr = arr[v]
        else
          return
        end
      end
    end
    buf = needle:split2(":")
    if #buf == 2 then 
      if arr[buf[1]] then
        local t = getmetatable(arr[buf[1]])
        if t and t.__index then 
          arr = t.__index 
          needle = buf[2]
        end
      end
    end
    print(arr, needle, s.tabindex)
    k, v = table.findindex(arr, needle)
    if k then 
      buf = 0
      if type(v) == 'function' then k = k .. '()' buf = 1 end
      s.input = s.tabstr:sub(1, s.tabstr:len() - needle:len()) .. k
      s.cursor = s.input:len() - buf
    end
	elseif key == "right" then
		s.cursor = s.cursor + 1
		if s.cursor > s.input:len() then
			s.cursor = s.input:len()
		end
    s.tabindex = 1
  elseif key == "backspace" then 
    if s.tabindex ~= 1 then
      s.input = s.tabstr
      s.cursor = s.input:len()
      s.tabindex = 1
    else
      if s.cursor > 0 then
        s.input = s.input:sub(1, s.cursor - 1) .. s.input:sub(s.cursor + 1, s.input:len())
        s.cursor = s.cursor - 1
        s.tabstr = s.input
      end
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
    s.history_cursor = #s.history
    s.history[#s.history] = s.input
    s.tabstr = s.input
    s.tabindex = 1
  end
end

if not gameoptions.console_history then gameoptions.console_history = {""} end

local _old_print = print
--Override print
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
debug_screen = E:new()
:size(800, 200)
:move(0, 627)
:set({lines = {}, input = "", cursor = 0, disabled = true, history = gameoptions.console_history, history_cursor = #gameoptions.console_history, tabindex = 1, tabstr = ""})
:draw(function(s)
  G.setColor(0,0,0,190)
  G.rectangle("fill", s.x, s.y, s.w, s.h)
  G.rectangle("fill", s.x+720, s.y - 26, s.w - 720, 26)
  G.setColor(0,0,0,255)
  G.rectangle("line", s.x, s.y, s.w, s.h)
  G.rectangle("line", s.x+720, s.y - 26, s.w - 720, 26)
  G.fontSize = 24 / screen_scale
  G.setFont(small)
  G.setColor(255,255,255,255)
  G.line(s.x, s.y + 186, s.w, s.y + 186)
  Gprintf('fps: '..love.timer.getFPS() .. '\nMemory: ' .. gcinfo(), s.x, s.y - 24, s.w, "right")
  Gprintf('> ' .. s.input,s.x,s.y + 188,s.w)
  local lines = math.ceil(180 * screen_scale / 12)
  if math.sin(time*6) > 0 then
    Gprint('|', (small:getWidth('> ') + small:getWidth(string.sub(s.input, 0, s.cursor)) - 2) / screen_scale, s.y + 188)
  end
  local c, i = 0, 0
  for i = math.max(#s.lines - lines + 1, 1), #s.lines do
    Gprint(s.lines[i], s.x, s.y + c * 12 / screen_scale)
    c = c + 1
  end
end)
table.print(getmetatable(screen))
print(table.findindex(_G, 'pr'))