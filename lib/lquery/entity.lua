local easing = require("lib/lquery/easing")

lQuery = {
	fx = true,
	hooks = {},
	_onresize = {},
	addhook = function(hook)
		table.insert(lQuery.hooks, hook)
	end,
	onresize = function(func)
		table.insert(lQuery._onresize, func)
	end,
	_MousePressedOwner = false,
	MousePressed = false
}


Entity = {} --Any object: box, circle, character etc
E = Entity --short name
local EntityMeta = {
	__index = Entity
}
--special metatable for objects that have update callbacks
local EntityMetaUpdate = {
	__index = function(t, k)
		if t.__data[k] then return t.__data[k] end
		if Entity[k] then return Entity[k] end
	end,
	__newindex = function(t, k, v)
		rawset(t.__data, k, v)
		if t.upd[k] then t.upd[k](t, v) end
	end
}
function Entity:new(parent)  -- constructor
	local object = {
		x = 0,   --x coord
		y = 0,   --y coord
		_visible = true --visibility
	}
	setmetatable(object, EntityMeta)  -- Inheritance
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
--Sets angle (rotation) of entity
function Entity:rotate(angle)
	self.angle = angle or self.angle or 0
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
--toggle entity
function Entity:toggle()
	self._visible = not self._visible
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
local emptyArray={}
function Entity:animate(keys, options)
  if keys then
    if not self._animQueue then self._animQueue = {} end
    if not options then 
      options = emptyArray
    --each option has different type
    elseif type(options) == "number" then
      options = {speed = options}
    elseif type(options) == "function" then
      options = {cb = options}
    elseif type(options) == "string" then
      options = {easing = options}
    elseif type(options) == "boolean" then
      options = {loop = options}
    end
    local queue = options.queue or "main" --you can manage queues
    if not self._animQueue[queue] then self._animQueue[queue] = {} end
    table.insert(self._animQueue[queue], {
      keys = keys,
      old = {},
      speed = options.speed or 0.3,
      lasttime = nil, 
      easing = easing[options.easing] or easing.swing,
      loop = options.loop or false,
      callback = options.callback or options.cb,
      a = options.a,
      b = options.b
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

--�� ��� ��� ��������� ��� � ��� ������. ���� ������� � ���� �������� ����
--callbacks
for k, v in pairs({'click', 'mousepress', 'mouserelease', 'mouseover', 'mouseout', 'mousewheel', 'mousemove', 'keypress', 'keyrelease', 'keyrepeat', 'wheel'}) do
  Entity[v] = function (self, callback)
    if callback then
      if not self._bound then self._bound = Entity.bounds.rectangle end
      self._control = true
      self['_' .. v] = callback 
    end
    return self
  end
end

--special event: calls when parameter key was changed
function Entity:update(key, func)
	if type(func) == 'function' then
		if not self.__data then
			local data = {}
			setmetatable(self, nil)
			for k, v in pairs(self) do
				data[k] = v
				self[k] = nil
			end
			self.__data = data
			self.upd = {}
			setmetatable(self, EntityMetaUpdate)
		end
		if type(key) == 'table' then
			for _, v in ipairs(key) do self.upd[v] = func end
		else
			self.upd[key] = func
		end
	end
	return self --so we can chain methods
end

function Entity:draw(callback)
	if type(callback) == 'function' then
		if not self._draw then
			self._draw = callback
		else
			if type(self._draw) ~= 'table' then self._draw = {self._draw} end
			table.insert(self._draw, callback)
		end
	end
	return self --so we can chain methods
end

local drag_start = function(s, x, y)
  s._drag_x = x - s.x
  s._drag_y = y - s.y
  _drag_object = s
end
local drag_end = function(s)
  _drag_object = nil
end
lQuery.addhook(function()
  local s = _drag_object
  if s then
    s.x = mX - s._drag_x
    s.y = mY - s._drag_y
    if s._drag_bound then
      local a = s._drag_bound
      if s.x > a[2] then s.x = a[2] end
      if s.x < a[4] then s.x = a[4] end
      if s.y > a[3] then s.y = a[3] end
      if s.y < a[1] then s.y = a[1] end
    end
    if s._drag_callback then s._drag_callback(s, x, y) end
  end
end)
function Entity:draggable(options)
  local o = options or {}
  if o.bound then self._drag_bound = o.bound end --[[top, right, bottom, left]]
  if o.callback then self._drag_callback = o.callback end
  return self:mousepress(drag_start):mouserelease(drag_end)
end


--delete object
--how to remove object correctly and free memory:
--a = a:delete()
--~ function Entity:delete()
  --~ local i = 0
  --~ for k, v in pairs(self._parent._child) do
    --~ i = i + 1
    --~ if v == self then
      --~ table.remove(self._parent._child, i)
      --~ return nil
    --~ end
  --~ end
  --~ return nil
--~ end

--screen - parent entity for all entities. Drawing function recursively process all entities from it.
screen = Entity:new()

local function animate(ent)
  for i, j in pairs(ent._animQueue) do
    if j[1] then 
      aq = j[1]
      if not aq._keys then
        if type(aq.keys) == 'function' then
          aq._keys = aq.keys()
        else
          aq._keys = aq.keys
        end
      end
      if not aq.lasttime then
        aq.lasttime = time
        for k, v in pairs(aq._keys) do
          aq.old[k] = ent[k]
        end
      end
      
      if aq.lasttime + aq.speed <= time or lquery_fx == false then
        for k, v in pairs(aq._keys) do
          ent[k] = v
        end
        if aq.loop == true then
          aq._keys = nil
          aq.lasttime = nil
          aq.old = {}
          table.insert(j, aq) 
        end
        table.remove(j, 1)
        if aq.callback then aq.callback(ent) end
        animate(ent)
      else
        for k, v in pairs(aq._keys) do
          if ent[k] and type(ent[k]) == 'number' then ent[k] = aq.easing(time - aq.lasttime, aq.old[k], v - aq.old[k], aq.speed, aq.a, aq.b) end
        end
      end --if aq.lasttime + vv.speed <= time
    end --if j[1]
  end --for
end


--some events
local function events(v)
  if lQuery.KeyPressed == true then 
    if v._keypress then
      if not v._key or v._key ~= lQuery.KeyPressedKey then
        v._keypress(v, lQuery.KeyPressedKey, lQuery.KeyPressedUni)
      end
    end
    if not v._key or v._key ~= lQuery.KeyPressedKey then
      v._KeyPressedCounter = 1
    end
    if v._keyrepeat and (v._KeyPressedCounter == 1 or 
         v._KeyPressedCounter == 2 and time - v._KeyPressedTime > 0.3 or
         v._KeyPressedCounter > 2 and time - v._KeyPressedTime > 0.05) then 
      v._KeyPressedTime = time
      v._KeyPressedCounter = v._KeyPressedCounter + 1
      v._keyrepeat(v, lQuery.KeyPressedKey, lQuery.KeyPressedUni)
    end
    v._key = lQuery.KeyPressedKey
  else
    if v._keyrelease then
      if v._key and v._key == true then
        v._keyrelease(v, lQuery.KeyPressedKey, lQuery.KeyPressedUni)
      end
    end
    v._key = false
  end
  if v._bound and v._bound(v, mX, mY) then 
    
    if v._mousemove then 
      v._mousemove(v, mX, mY)
    end 
    if lQuery.MouseButton == "wu" then 
      if v._wheel then
        lQuery.MouseButton = nil
        v._wheel(v, mX, mY, "u")
      end
    elseif lQuery.MouseButton == "wd" then 
      if v._wheel then
        lQuery.MouseButton = nil
        v._wheel(v, mX, mY, "d")
      end
    elseif lQuery.MousePressed == true and lQuery._MousePressedOwner == true then 
      lQuery.MousePressedOwner = v
    end
    lQuery.hover = v
  else
    if lQuery._hover == v then 
      lQuery._hover = nil
      lQuery.hover = nil
      if v._mouseout then v._mouseout(v, mX, mY) end
      --if v == lQuery.MousePressedOwner then lQuery.MousePressedOwner = nil end
    end
  end
end

local function process_entities(ent)
	if ent._visible == true then 
		if ent._animQueue then 
			animate(ent) 
		end
		if ent._control then --if controlled
			events(ent)
		end
		if ent._draw then
			G.setColor(ent.r or 255, ent.g or 255, ent.b or 255, ent.a or 255)
			if ent.blendMode then G.setBlendMode(ent.blendMode) end
			if type(ent._draw) == 'function' then
				ent._draw(ent)
			else
				for _, v in ipairs(ent._draw) do v(ent) end
			end
			if ent.blendMode then G.setBlendMode('alpha') end
		end
		if ent._child then 
			for k, v in pairs(ent._child) do
				process_entities(v)
			end
		end
	end
end

lQuery.event = function(e, a, b, c)
  if e == "mp" then
    lQuery.MousePressed = true
    lQuery.MouseButton = c
    lQuery._MousePressedOwner = true
  elseif e == "mr" then 
    lQuery.MousePressed = false
    lQuery.MouseButton = c
    --click handler
    local v = lQuery.MousePressedOwner
    if v --[[and v._bound and v._bound(v, mX, mY)]] then
      local v = lQuery.MousePressedOwner
      if v._mouserelease then 
        v._mouserelease(v, mX, mY, c)
      end
      if v._click and v._bound and v._bound(v, mX, mY) then 
        v._click(v, mX, mY, c)
      end
    end
    lQuery.MousePressedOwner = nil
  elseif e == "kp" then
    lQuery.KeyPressed = true
    lQuery.KeyPressedKey = a
    lQuery.KeyPressedUni = b
  elseif e == "kr" then
    lQuery.KeyPressed = false
  elseif e == "rz" then
    screen_width = a
    screen_height = b
    if lQuery._onresize[1] then
      for i = 1, #lQuery._onresize do
	lQuery._onresize[i](a, b)
      end
    end
  elseif e == "q" then
    if atexit then atexit() end
  end
end

lQuery.process = function()
  for _, v in pairs(lQuery.hooks) do v() end

  if screen then process_entities(screen) end
  if Console then process_entities(Console) end
  
  --fix mousepress bug
  local v = lQuery.MousePressedOwner
  if v and lQuery._MousePressedOwner == true then
    if v._mousepress then 
      v._mousepress(v, mX, mY, lQuery.MouseButton)
    end
  end
  
  local v = lQuery.hover
  if v and not lQuery._hover then
    if v._mouseover then v._mouseover(v, mX, mY) end
    lQuery._hover = v
  end
  lQuery._MousePressedOwner = false
end
