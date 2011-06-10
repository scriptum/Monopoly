gameoptions = {}
table.insert(lquery_hooks, function()
	if KeyPressed == true and Console and Console.disabled == false and 
			(KeyPressedCounter == 1 or 
			 KeyPressedCounter == 2 and time - KeyPressedTime > 0.3 or
			 KeyPressedCounter > 2 and time - KeyPressedTime > 0.05) then 
		KeyPressedTime = time
		KeyPressedCounter = KeyPressedCounter + 1
		debug_keypressed(KeyPressedKey,KeyPressedUni)
	end
end)
local small = Fonts["Pt Sans"][8]
small:select()
function table.findindex(arr, needle)
  local i = 1, m
  local l = needle:len()
  if type(arr) ~= "table" then return nil, nil end
  for m = 1, 3 do
    for k, v in pairs(arr) do
      if string.sub(k, 1, l) == needle then
        if i == Console.tabindex then
          Console.tabindex = Console.tabindex + 1
          return k, v
        else
          i = i + 1
        end
      end
    end
    if Console.tabindex == 1 then
      break
    else
      Console.tabindex = 1
      i = 1
    end
  end
  return nil, nil
end

debug_keypressed = function(key, unicode)
  local s = Console
  if key == "`" or key == "escape" then
  elseif key =="return" then
    table.insert(s.lines, '> ' .. s.input)
    if s.history_cursor == #s.history and s.input:len() > 0 then table.insert(s.history, "") end
    s.history_cursor = #s.history
    xpcall(loadstring("print("..s.input..")"), function()xpcall(loadstring(s.input), print)end)
    s.input = ""
    s.cursor = 0
    s.tabupdate(s)
  elseif key == "left" then
		s.cursor = s.cursor - 1
		if s.cursor < 0 then s.cursor = 0 end
    s.tabupdate(s)
  elseif key == "up" then
    s.history_cursor = s.history_cursor - 1
    if s.history_cursor < 1 then s.history_cursor = 1 end
    s.input = s.history[s.history_cursor]
    s.cursor = s.input:len()
    s.tabupdate(s)
  elseif key == "down" then
    s.history_cursor = s.history_cursor + 1
    if s.history_cursor > #s.history then s.history_cursor = #s.history end
    s.input = s.history[s.history_cursor]
    s.cursor = s.input:len()
    s.tabupdate(s)
  elseif key == "home" then
    s.cursor = 0
    s.tabupdate(s)
  elseif key == "end" then
    s.cursor = s.input:len()
    s.tabupdate(s)
  elseif key == "tab" then
    local needle = s.tabstr:gsub(".*[ {}()\%[=+*/#-]", "")
    local arr = _G
    local buf = needle:split2("[.]")
    local k, v
    for k,v in ipairs(buf or {}) do
      if k + 0 == #buf then needle = v
      else if arr[v] then arr = arr[v] else return end
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
    k, v = table.findindex(arr, needle)
    if k then
      buf = 0
      if type(v) == 'function' then k = k .. '()' buf = 1 end
      local buf2 = s.tabstr:sub(1, s.tabstr:len() - needle:len()) .. k
      s.input = buf2 .. s.tabstr2
      s.history[#s.history] = s.input
      s.cursor = buf2:len() - buf
    end
	elseif key == "right" then
		s.cursor = s.cursor + 1
		if s.cursor > s.input:len() then
			s.cursor = s.input:len()
		end
    s.tabupdate(s)
  elseif key == "backspace" then
    if s.tabindex ~= 1 then
      s.input = s.tabstr .. s.tabstr2
      s.cursor = s.tabstr:len()
      s.tabupdate(s)
    else
      if s.cursor > 0 then
        s.input = s.input:sub(1, s.cursor - 1) .. s.input:sub(s.cursor + 1, s.input:len())
        s.cursor = s.cursor - 1
        s.tabupdate(s)
      end
    end
    s.history_cursor = #s.history
    s.history[#s.history] = s.input
  elseif key == "delete" then
    if s.cursor < string.len(s.input) then
      s.input = s.input:sub(1, s.cursor) .. s.input:sub(s.cursor + 2, s.input:len())
    end
  else
    if unicode ~= nil and unicode ~= 0 then
      local char = string.char(unicode%255)
      if s.cursor == s.input:len() then
        s.input = s.input .. char
      else
        s.input = s.input:sub(1, s.cursor) .. char .. s.input:sub(s.cursor + 1, s.input:len())
      end
      s.cursor = s.cursor + 1
    end
    s.history_cursor = #s.history
    s.history[#s.history] = s.input
    s.tabupdate(s)
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
	table.insert(Console.lines, str)
end
Console = E:new()
:size(800, 200)
:move(0, 600 + 31 / screen_scale)
:set({lines = {}, input = "", cursor = 0, disabled = true, history = gameoptions.console_history, history_cursor = #gameoptions.console_history, tabindex = 1, tabstr = "", tabstr2 = "", tabupdate = function(s) s.tabstr = s.input:sub(1, s.cursor) s.tabstr2 = s.input:sub(s.cursor + 1, s.input:len()) s.tabindex = 1 end})
:draw(function(s)
  if(s.y >= 600) then return end
  scrupp.setLineWidth(1/screen_scale)
  scrupp.setSmooth(false)
  G.setColor(20,20,20,190)
  local x, y, w, h = math.floor(s.x), math.floor(s.y), math.floor(s.w), math.floor(s.w)
  local off1 = (w - 700) / screen_scale
  local sh = small:height()
  local off2 = (sh*2 + 2) / screen_scale
  local off3 = (sh + 1) / screen_scale
  G.rectangle(x, y, w, h, true)
  G.rectangle(w - off1, y - off2, off1, off2, true)
  G.setColor(128,128,128,255)
  G.rectangle(x, y, w, h)
  G.rectangle(w - off1 - 2, y - off2, off1 + 2, off2)
  small:select()
  G.setColor(255,255,255,255)
  G.line(x, y + 200 - off3, w, y + 200 - off3)
  scrupp.print('fps: '..scrupp.fps() .. '\nMemory: ' .. gcinfo(), w - off1, y - off2)
  scrupp.print('> ' .. s.input,x,y + 200 - sh - 1)
  local lines = math.ceil(180 * screen_scale / sh)
  local lx = (small:width('> ') + small:width(string.sub(s.input, 0, s.cursor))) / screen_scale
  local ly = y + 200
  if math.sin(time*6) > 0 then
    scrupp.line(lx, ly - sh, lx, ly)
  end
  local c, i = 0, 0
  for i = math.max(#s.lines - lines + 1, 1), #s.lines do
    scrupp.print(s.lines[i], x, y + c * sh / screen_scale)
    c = c + 1
  end
end)