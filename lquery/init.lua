local easing = require("lquery.easing")
require("lquery.string")
require("lquery.table")
require("lquery.entity")

G = love.graphics --graphics
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
      
      if aq.lasttime + aq.speed <= time then
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
      else
        for k, v in pairs(aq._keys) do
          if ent[k] then ent[k] = easing[aq.easing](time - aq.lasttime, aq.old[k], v - aq.old[k], aq.speed) end
        end
      end --if aq.lasttime + vv.speed <= time
    end --if j[1]
  end --for
end

local MousePressed = false
local MouseButton = nil
--some mouse events
local function events(v)
  if v._bound and v._bound(v, mX, mY) then
    if MousePressed == true then
      if not v._mousePress or v._mousePress == false then
        v._mousePress = true
        if v._mousepress then v._mousepress(v, mX, mY, MouseButton) end
      end
    else
      if v._mousePress == true then
        if v._click then v._click(v, mX, mY, MouseButton) end
        if v._mouserelease then v._mouserelease(v, mX, mY) end
      end
      v._mousePress = false
    end
    if not v._hasMouse or v._hasMouse == false then
      v._hasMouse = true
      if v._mouseover then v._mouseover(v, mX, mY) end
    end
  else
    v._mousePress = false
    if v._hasMouse and v._hasMouse == true then
      v._hasMouse = false
      if v._mouseout then v._mouseout(v, mX, mY) end
    end
  end
end

local function process_entities(ent)
  if ent._animQueue then 
    animate(ent) 
  end
  if ent._control then --if mouse controlled
    events(ent)
  end
  if ent._visible == true then
    G.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
    if ent._draw then ent._draw(ent) end
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
    if love.graphics then
      love.graphics.clear()
      time = love.timer.getTime()
      if screen then process_entities(screen) end
      if love.draw then love.draw() end
    end --if love.graphics
    --if love.timer then love.timer.sleep(1) end
    if love.graphics then love.graphics.present() end

  end
end
