local function list_mousepress(s, x, y, b)
  local r = s._vars
  if b == 'l' then
    var_by_reference(s._variable, next(r, var_by_reference(s._variable)) or next(r))
  end
end

--label: list description
--vars: list of possible vars
--vars_names: display names of possible vars
--variable: variable to affect
--when user click on list, next value from "vars" puts into "variable"
--косяк: lua не умеет передавать обычные переменные по ссылке
function Entity:list(label, vars, vars_names, variable)
  self.text = label or ''
  self._vars = {}
  for k, v in pairs(vars) do
    self._vars[v] = vars_names[k]
  end
  self._variable = variable
  self._draw = ui_style.list.draw
  self._bound = Entity.bounds.rectangle
  self.w = ui_style.list.w
  self.h = ui_style.list.h
  self.sx = ui_style.list.sx or 1
  self.sy = ui_style.list.sy or 1
  self.a = 255
  self:mouseover(ui_style.list.mouseover):mouseout(ui_style.list.mouseout):mousepress(list_mousepress)
  return self
end

