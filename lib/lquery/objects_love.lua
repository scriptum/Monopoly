--point
local point_draw = function(s)
  oldsize = G.getPointSize()
  G.setPointSize(s.R * 2)
  G.point(s.x, s.y)
  G.setPointSize(oldsize)
end
function Entity:point(R)
  self.R = R or 1
  self._draw=point_draw
  self._bound = Entity.bounds.circle
  return self
end

--circle
local circle_draw = function(s)
  G.circle("fill", s.x, s.y, s.R, 2*s.R)
end
function Entity:circle(radius)
  self.R = radius or 10
  self._draw=circle_draw
  self._bound = Entity.bounds.circle
  return self
end

--text
local text_draw = function(s)
  G.fontSize = s.fontSize or 12
  if s.w then
    G.printf(s.text, s.x, s.y, s.w, s.align)
  else
    G.print(s.text, s.x, s.y)
  end
end
function Entity:text(text, size, align)
  self.fontSize = size
  self.text = text or ''
  self.align = align
  self._draw = text_draw
  return self
end

--image
local image_draw = function(s)
  G.draw(s.image, s.x, s.y, s.angle, s.sx, s.sy, s.ox, s.oy)
end
function Entity:image(image)
 if image then
    if type(image) == 'string' then image = G.newImage(image) end
    self.image = image
    self._draw = image_draw
    self.w = image:getWidth()
    self.h = image:getHeight()
    self.angle = 0
    self.sx = 1
    self.sy = 1
  end
  return self
end

--border-image
local border_image_draw = function(s)
  local b = s.border
  local i = s._image
  local x = s.x
  local y = s.y
  G.drawq(i, s.img_tl, x, y)
  G.drawq(i, s.img_tc, x + b.left, y, 0, (s.w - b.left - b.right)/(s.orig_w - b.left - b.right), 1)
  G.drawq(i, s.img_tr, x + s.w - b.right, y)
  G.drawq(i, s.img_cl, x, y + b.top, 0, 1, (s.h - b.top - b.bottom)/(s.orig_h - b.top - b.bottom))
  G.drawq(i, s.img_cc, x + b.left, y + b.top, 0, (s.w - b.left - b.right)/(s.orig_w - b.left - b.right), (s.h - b.top - b.bottom)/(s.orig_h - b.top - b.bottom))
  G.drawq(i, s.img_cr, x + s.w - b.right, y + b.top, 0, 1, (s.h - b.top - b.bottom)/(s.orig_h - b.top - b.bottom))
  G.drawq(i, s.img_bl, x, y + s.h - b.bottom)
  G.drawq(i, s.img_bc, x + b.left, y + s.h - b.bottom, 0, (s.w - b.left - b.right)/(s.orig_w - b.left - b.right), 1)
  G.drawq(i, s.img_br, x + s.w - b.right, y + s.h - b.bottom)
end
lQuery.border_image_draw = border_image_draw
function Entity:border_image(image, top, right, bottom, left)
 if image then
    if type(image) == 'string' then image = G.newImage(image) end
    self._image = image
    self._draw = border_image_draw
    w = image:getWidth()
    h = image:getHeight()
    self.w = w
    self.h = h
    self.orig_w = w
    self.orig_h = h
    
    self.img_tl = G.newQuad(0, 0, left, top, w, h)
    self.img_tc = G.newQuad(left, 0, w - left - right, top, w, h)
    self.img_tr = G.newQuad(w - right, 0, right, top, w, h)
    
    self.img_cl = G.newQuad(0, top, left, h - top - bottom, w, h)
    self.img_cc = G.newQuad(left, top, w - left - right, h - top - bottom, w, h)
    self.img_cr = G.newQuad(w - right, top, right, h - top - bottom, w, h)
    
    self.img_bl = G.newQuad(0, h - bottom, left, bottom, w, h)
    self.img_bc = G.newQuad(left, h - bottom, w - left - right, bottom, w, h)
    self.img_br = G.newQuad(w - right, h - bottom, right, bottom, w, h)
    
    self.border = {top = top, right = right, bottom = bottom, left = left}
    
    self.angle = 0
    self.sx = 1
    self.sy = 1
  end
  return self
end