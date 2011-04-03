local function list_mousepress(self, x, y, b)
  r = self._vars
  t = self._table
  v = self._table_value
  if b == 'l' or b == 'wu' then
    t[v] = next(r, t[v]) or next(r)
  end
end

--label: list description
--vars: list of possible vars
--variable: variable to affect
--when user click on list, new value from "vars" puts into "variable"
--косяк: lua не умеет передавать обычные переменные по ссылке, поэтому по сслыке пришлось передавать таблицу и индекс втаблице который нужно менять.
function Entity:list(label, vars, tabl, value)
  self.text = label or ''
  --self._vars = {}
  self._vars = vars or {}
  self._table = tabl --таблица передаваемая по ссылке, в которой нужно менять значение _table_value
  self._table_value = value
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

