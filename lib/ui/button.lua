local act = function(s,x,y,b)
  if s.disabled == false then 
    s._action(s,x,y,b) 
  end 
end
function Entity:button(text, action)
  self.text = text or ''
  if action then
    self._action = action
    self._click = act
  end
  self._draw = ui_style.button.draw
  self._bound = Entity.bounds.rectangle
  if not self.w then self.w = ui_style.button.w end
  if not self.h then self.h = ui_style.button.h end
  self.sx = self.w / ui_style.button.w
  self.sy = self.h / ui_style.button.h
  self.angle = 0
  self.disabled = false
  self.hover_alpha = 0 --alpha channel for hover image
  self.a = 230
  self:mouseover(ui_style.button.mouseover):mouseout(ui_style.button.mouseout)
  return self
end