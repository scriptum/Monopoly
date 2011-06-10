--получение переменной по ссылке и задание ей значения невозможны в луа, так что костыли
--TODO заюзать динамические функции!!
var_by_reference = function(var, value)
  if type(var) == 'table' then
    if #var == 1 then
      if value then _G[var[1]] = value else return _G[var[1]] end
    elseif #var == 2 then
      if value then _G[var[1]][var[2]] = value else return _G[var[1]][var[2]] end
    elseif #var == 3 then
      if value then _G[var[1]][var[2]][var[3]] = value else return _G[var[1]][var[2]][var[3]] end
    end
  else
    if value then _G[var] = value else return _G[var] end
  end
end

lquery_fx = true
lquery_hooks = {}

local easing = require("lib/lquery/easing")
require("lib/lquery/entity")
S = scrupp
love = {}
love.graphics = {
  newImage = S.newImage,
  setColor = S.setColor,
  setBlendMode = S.setBlendMode,
  rectangleFilled = S.rectangleFilled,
  rectangle = S.rectangle,
  line = S.line,
  point = S.point,
}
love.audio = {newImage = scrupp.addImage}
love.filesystem = {newImage = scrupp.addImage}
G = love.graphics --graphics
A = love.audio --audio
F = love.filesystem --files

getMouseXY = function()
  return S.getMousePos()
end

local function animate(ent)
  for i, j in pairs(ent._animQueue) do
    if j[1] then 
      aq = j[1]
      if not aq._keys then
        if type(aq.keys) == 'function' then
          aq._keys = aq.keys()
        else
          aq._keys = aq.keys
        end
      end
      if not aq.lasttime then
        aq.lasttime = time
        for k, v in pairs(aq._keys) do
          aq.old[k] = ent[k]
        end
      end
      
      if aq.lasttime + aq.speed <= time or lquery_fx == false then
        for k, v in pairs(aq._keys) do
          ent[k] = v
        end
        if aq.loop == true then
          aq._keys = nil
          aq.lasttime = nil
          aq.old = {}
          table.insert(j, aq) 
        end
        table.remove(j, 1)
        if aq.callback then aq.callback(ent) end
        animate(ent)
      else
        for k, v in pairs(aq._keys) do
          if ent[k] and type(ent[k]) == 'number' then ent[k] = easing[aq.easing](time - aq.lasttime, aq.old[k], v - aq.old[k], aq.speed) end
        end
      end --if aq.lasttime + vv.speed <= time
    end --if j[1]
  end --for
end

MousePressed = false
MousePressedOwner = nil
MouseButton = nil
--some mouse events
local function events(v)
  if KeyPressed == true then 
    if v._keypress then
      if not v._key or v._key == false then
        v._keypress(KeyPressedKey, KeyPressedUni)
      end
    end
    v._key = true
  else
    if v._keyrelease then
      if v._key and v._key == true then
        v._keyrelease(KeyPressedKey, KeyPressedUni)
      end
    end
    v._key = false
  end
  if v._bound and v._bound(v, mX, mY) then
    if v._mousemove then 
      __mousemove = v
    end
    if MousePressed == true and not MousePressedOwner then
      if v._mousepress or v._click then 
        __mousepress = v
      end
    end
    if not v._hasMouse or v._hasMouse == false then
      v._hasMouse = true
      if v._mouseover then __mouseover = v end
    end
  else
    if v._hasMouse and v._hasMouse == true then 
      v._hasMouse = false
      if v._mouseout then v._mouseout(v, mX, mY) end
    end
  end
end

local function process_entities(ent)
  if ent._visible == true then 
    if ent._animQueue then 
      animate(ent) 
    end
    if ent._control then --if controlled
      events(ent)
    end
    if ent._draw then 
      S.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
      if ent.blendMode then S.setBlendMode(ent.blendMode) end
      ent._draw(ent)
      if ent.blendMode then S.setBlendMode('alpha') end
    end
    if ent._child then 
      for k, v in pairs(ent._child) do
        process_entities(v)
      end
    end
  end
end


--~ lasttimer = 0


main ={
	render = function()
    --if love.load then love.load(arg) end
    --time = 0
    -- Main loop time.
    --while true do
    mX, mY = getMouseXY()

    time = scrupp.getTicks() / 1000
    --~ if lasttimer + 1 < time then
      --~ lasttimer = time
    --~ end
    
    for _, v in pairs(lquery_hooks) do
      v()
    end

    __mousepress, __mouseover = nil, nil
    
    if screen then process_entities(screen) end
    if Console then process_entities(Console) end
    
    --это чтобы исправить косяк, когда множество наложенных друг на друга элементов получает событие клик
    --если таких элементов было очень много, двиг замирал, обрабатывая множество кликов
    if __mousemove then
      __mousemove._mousemove(__mousemove, mX, mY, MouseButton)
    end
    if __mouseover then
      __mouseover._mouseover(__mouseover, mX, mY, MouseButton)
    end
    if __mousepress then
      if __mousepress._mousepress then __mousepress._mousepress(__mousepress, mX, mY, MouseButton) end
      MousePressedOwner = __mousepress
    end
    if MousePressed == false and MousePressedOwner then
      if MousePressedOwner._mouserelease then MousePressedOwner._mouserelease(v, mX, mY) end
      if MousePressedOwner._hasMouse == true and MousePressedOwner._click then MousePressedOwner._click(MousePressedOwner, mX, mY, MouseButton) end
      MousePressedOwner = nil
    end

  end,
	mousepressed = function(x, y, button)
		MousePressed = true
		MouseButton = button
	end,
	mousereleased = function(x, y, button)
		MousePressed = false
		MouseButton = button
	end,
  keypressed = function(key, unicode)
		KeyPressed = true
		KeyPressedKey = key
    KeyPressedUni = unicode
    KeyPressedCounter = 1
    if key == "`" and Console then 
      if Console.disabled == true then
        Console:stop():animate({y = 400})
      else
        Console:stop():animate({y = 600 + 31 / screen_scale})
      end
      Console.disabled = not Console.disabled
    end
	end,
  keyreleased = function()
		KeyPressed = false
	end,
}