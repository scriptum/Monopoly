Entity = {} --Any object: box, circle, character etc
E = Entity --short name
function Entity:new(parent)  -- constructor
  local object = {
    x = 0,   --x coord
    y = 0,   --y coord
    _visible = true
    }
  setmetatable(object, { __index = Entity })  -- Inheritance
  --table.insert(Entities,  object)
  --object._key = #Entities
  --append this entity to the parent
  --print(parent)
  if parent then parent:append(object) end
  return object
end

--Sets vars of entity
function Entity:set(vars)
  for k, v in pairs(vars) do
    self[k] = v
  end
  return self --so we can chain methods
end
--Sets x and y position of entity
function Entity:move(x, y)
  self.x = x or self.x or 0
  self.y = y or self.y or 0
  return self --so we can chain methods
end
--Sets x scale and y scale
function Entity:scale(sx, sy)
  self.sx = sx or 1
  self.sy = sy or 1
  return self --so we can chain methods
end
--Sets radius of entity
function Entity:radius(R)
  self.R = R or self.R or 0
  return self --so we can chain methods
end
--Sets width and height of entity
function Entity:size(w, h)
  self.w = w or self.w or 0
  self.h = h or self.h or 0
  return self --so we can chain methods
end
--Sets color of entity
function Entity:color(r, g, b, a)
  self.r = r or self.r or 255
  self.g = g or self.g or 255
  self.b = b or self.b or 255
  self.a = a or self.a or 255
  return self --so we can chain methods
end
--hide entity (stop processing events and drawing) children will be hidden too
function Entity:hide()
  self._visible = false
  return self --so we can chain methods
end
--show hidden entity
function Entity:show()
  self._visible = true
  return self --so we can chain methods
end
--append child
function Entity:append(child)
  if not self._child then self._child = {} end
  table.insert(self._child, child)
  child._parent = self
  return self --so we can chain methods
end

--Animates all values of entity to the given values in keys with the given speed
--examples:
--ent:animate({x=100,y=100}, 0.3) - move entity to 100, 100 for 300 msecs
--ent:animate({r=0,g=0,b=0,a=0}, {speed=0.3, easing='linear'}) - fade down with given easing function
--ent:animate({value=29, frame=53}, 2) - animate specific parameters of entity
function Entity:animate(keys, options)
  if keys then
    if not self._animQueue then self._animQueue = {} end
    if not options then 
      options = {}
    elseif type(options) == "number" then
      options = {speed = options}
    elseif type(options) == "function" then
      options = {cb = options}
    elseif type(options) == "string" then
      options = {easing = options}
    elseif type(options) == "boolean" then
      options = {loop = options}
    end
    local queue = options.queue or "main" --you can manage with some queues
    if not self._animQueue[queue] then self._animQueue[queue] = {} end
    table.insert(self._animQueue[queue], {
      keys = keys,
      old = {},
      speed = (options.speed or 0.3),
      lasttime = nil, 
      easing = options.easing or 'swing', --swing or linear
      loop = options.loop or false,
      callback = options.callback or options.cb
    })
  end
  return self --so we can chain methods
end

--delay between animations inn one queue
function Entity:delay(options)
  return self:animate({}, options)
end

--stop animation
--ent:stop() - stop all animations
--ent:stop('anim_group_1') - stop all animatios in queue 'anim_group_1'
function Entity:stop(queue)
  if not self._animQueue then self._animQueue = {} end
  if queue then
    self._animQueue[queue] = {}
  else
    self._animQueue = {}
  end
  return self --so we can chain methods
end

--bounding functions
Entity.bounds = {
  rectangle = function(ent, mouseX, mouseY)
    return  ent.w and ent.h
            and ent.x < mouseX 
            and ent.y < mouseY 
            and ent.x + ent.w > mouseX 
            and ent.y + ent.h > mouseY
  end,
  circle = function(ent, mouseX, mouseY)
    return ent.R and (math.pow(mouseX-ent.x, 2)+math.pow(mouseY-ent.y, 2) < ent.R*ent.R)
  end
}

--set bounding function for interaction with mouse
function Entity:bound(callback)
  if callback then self._bound = callback end
  return self --so we can chain methods
end

--до сих пор охреневаю как я это сделал. Куча методов в пяти строчках кода
--callbacks
for k, v in pairs({'click', 'mousepress', 'mouserelease', 'mouseover', 'mouseout', 'mousewheel'}) do
  Entity[v] = function (self, callback)
    if callback then
      if not self._bound then self._bound = Entity.bounds.rectangle end
      self._control = true
      self['_' .. v] = callback 
    end
    return self
  end
end



function Entity:draw(callback)
  if callback then self._draw = callback end
  return self --so we can chain methods
end

local drag_start = function(s, x, y)
  s._drag_x = x - s.x
  s._drag_y = y - s.y
  _drag_object = s
end
local drag_end = function()
  _drag_object = nil
end
function Entity:draggable(options)
  local o = options or {}
  if o.bound then self._drag_bound = o.bound end --[[top, right, bottom, left]]
  if o.callback then self._drag_callback = o.callback end
  return self:mousepress(drag_start):mouserelease(drag_end)
end
--delete object
--how to remove object correctly and free memory:
--a = a:delete()
function Entity:delete()
  local i = 0
  for k, v in pairs(self._parent._child) do
    i = i + 1
    if v == self then
      table.remove(self._parent._child, i)
      return nil
    end
  end
  return nil
end



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


--image
local image_draw = function(s)
  G.draw(s.image, s.x, s.y, s.angle, s.sx, s.sy)
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
  local i = s.image
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
function Entity:border_image(image, top, right, bottom, left)
 if image then
    if type(image) == 'string' then image = G.newImage(image) end
    self.image = image
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


--screen - parent entity for all entities. Drawing function recursively process all entities from it.
screen = Entity:new()