--items: {text='', action=function(), type='button|list...'}
function Entity:menu(items)
  local y = ui_style.menu.start or 30
  local margin = ui_style.menu.margin or 10
  local temp
  for k, v in pairs(items) do
    temp = Entity:new(self):button(v.text, v.action)
    if v.offset then y = y + v.offset end
    temp:move(400-temp.w/2, y)
    y = y + temp.h + margin
  end
  return self
end

function Entity:menutoggle(menu)
  self:toggle()
  menu:toggle()
end