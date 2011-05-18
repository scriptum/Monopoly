--получение переменной по ссылке и задание ей значения невозможны в луа, так что костыли
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

local easing = require("lib.lquery.easing")
require("lib.lquery.string")
require("lib.lquery.table")
require("lib.lquery.entity")

G = love.graphics --graphics
A = love.audio --audio
F = love.filesystem --files
getMouseXY = function()
  return love.mouse.getX(), love.mouse.getY()
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
    if ent._control then --if mouse controlled
      events(ent)
    end
    if ent._draw then 
      G.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
      if ent.blendMode then G.setBlendMode(ent.blendMode) else G.setBlendMode('alpha') end
      ent._draw(ent) 
    end
    if ent._child then 
      for k, v in pairs(ent._child) do
        process_entities(v)
      end
    end
  end
end

function love.run()
  if love.load then love.load(arg) end

  local dt = 0
  time = 0
  -- Main loop time.
  while true do
    if love.timer then
      love.timer.step()
      dt = love.timer.getDelta()
    end
    if love.update then
      love.update(dt)
    end
    -- Process events.
    if love.event then
      for e,a,b,c in love.event.poll() do
        if e == "q" then
          if not love.quit or not love.quit() then
            if love.audio then
              love.audio.stop()
            end
            return
          end
        end
        if e == "mp" then 
          MousePressed = true 
          MouseButton = c
        end
        if e == "mr" then MousePressed = false end
        love.handlers[e](a,b,c)
      end
    end
    mX, mY = getMouseXY()
    if G then
      G.clear()
      time = love.timer.getTime()
      
      for _, v in pairs(lquery_hooks) do
        v()
      end

      __mousepress, __mouseover = nil, nil
      if screen then process_entities(screen) end
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
      if love.draw then love.draw() end
      G.present()
    end --if G
  end
end
