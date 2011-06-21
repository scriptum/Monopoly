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
S = scrupp
require("lib/lquery/entity")

lQuery.MousePressed = false
main ={
	render = function()
    mX, mY = getMouseXY()

    time = scrupp.getTicks() / 1000
    --events
    local e, a, b, c = scrupp.poll()
    if e then
      if e == "mp" then
        lQuery.MousePressed = true
        lQuery.MouseButton = c
      elseif e == "mr" then 
        lQuery.MousePressed = false
        lQuery.MouseButton = c
        --click handler
        local v = lQuery.MousePressedOwner
        if v and v._bound(v, mX, mY) then
          local v = lQuery.MousePressedOwner
          if v._mouserelease then 
            v._mouserelease(v, mX, mY, c)
          end
          if v._click then 
            v._click(v, mX, mY, c)
          end
        end
        lQuery.MousePressedOwner = nil
      elseif e == "kp" then
        lQuery.KeyPressed = true
        lQuery.KeyPressedKey = a
        lQuery.KeyPressedUni = b
        lQuery.KeyPressedCounter = 1
      elseif e == "kr" then
        lQuery.KeyPressed = false
      elseif e == "q" then
        if atexit then atexit() end
      end
    end
    
    for _, v in pairs(lQuery.hooks) do
      v()
    end
    
    if screen then process_entities(screen) end
    if Console then process_entities(Console) end
    
  end
}