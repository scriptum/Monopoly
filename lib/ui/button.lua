function Entity:button(text, action)
  self.text = text or ''
  if action then self._click = action end
  self._draw = ui_style.button.draw
  self._bound = Entity.bounds.rectangle
  self.w = ui_style.button.w
  self.h = ui_style.button.h
  self.sx = ui_style.button.sx or 1
  self.sy = ui_style.button.sy or 1
  self.angle = 0
  self.hover_alpha = 0 --alpha channel for hover image
  self.a = 230
  self:mouseover(ui_style.button.mouseover):mouseout(ui_style.button.mouseout)
  return self
end