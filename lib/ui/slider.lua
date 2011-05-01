local function slider_drag_callback(s, x, y)
  local v = (s.x - s._parent.x-248+7)/(150-17)*(s._max - s._min) + s._min
  var_by_reference(s._parent._variable, v)
  if(s._callback) then s._callback(v) end
end

function Entity:slider(label, min, max, variable, callback)
  self.text = label or ''
  self._variable = variable
  
  self._draw = ui_style.slider.draw
  self._bound = Entity.bounds.rectangle
  self.w = ui_style.slider.w
  self.h = ui_style.slider.h
  self.sx = ui_style.slider.sx or 1
  self.sy = ui_style.slider.sy or 1
  self.a = 255
  self:mouseover(ui_style.slider.mouseover):mouseout(ui_style.slider.mouseout)
  
  Entity:new(self)
  :set({
    bound = Entity.bounds.rectangle, 
    w = ui_style.slider.button.w,
    h = ui_style.slider.button.h,
    _min = min,
    _max = max,
    _callback = callback
   })
  :move(self.x+248-7+(150-17)*(var_by_reference(variable) - min)/(max-min), self.y-2)
  :draw(ui_style.slider.button_draw)
  :draggable({
    bound = {self.y-2, self.x+399+7-32, self.y-2, self.x+248-7},
    callback = slider_drag_callback
   })
  return self
end