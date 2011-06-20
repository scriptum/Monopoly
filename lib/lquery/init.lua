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
    local e, a, b, c = scrupp.poll()
    if e then
      if e == "mp" then
        lQuery.MousePressed = true
        lQuery.MouseButton = c
      elseif e == "mr" then 
        lQuery.MousePressed = false
        lQuery.MouseButton = c
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

    --~ __mousepress, __mouseover = nil, nil
    
    if screen then process_entities(screen) end
    if Console then process_entities(Console) end
    
    --это чтобы исправить косяк, когда множество наложенных друг на друга элементов получает событие клик
    --если таких элементов было очень много, двиг замирал, обрабатывая множество кликов
    --~ if __mousemove then
      --~ __mousemove._mousemove(__mousemove, mX, mY, lQuery.MouseButton)
    --~ end
    --~ if __mouseover then
      --~ __mouseover._mouseover(__mouseover, mX, mY, lQuery.MouseButton)
    --~ end
    --~ if __mousepress then
      --~ if __mousepress._mousepress then __mousepress._mousepress(__mousepress, mX, mY, lQuery.MouseButton) end
      --~ MousePressedOwner = __mousepress
    --~ end
    --~ if MousePressed == false and MousePressedOwner then
      --~ if MousePressedOwner._mouserelease then MousePressedOwner._mouserelease(v, mX, mY) end
      --~ if MousePressedOwner._hasMouse == true and MousePressedOwner._click then MousePressedOwner._click(MousePressedOwner, mX, mY, lQuery.MouseButton) end
      --~ MousePressedOwner = nil
    --~ end
  end
}