return {
  button = {
    image = G.newImage('data/gfx/menu-button.png'),
    --font = G.newFont('data/fonts/ru.ttf', 32),
    font_color = {0,0,0,255},
    w = 256, h = 64,
    normal = {
      quad = G.newQuad(0, 0, 256, 64, 256, 128)
    },
    hover = {
      quad = G.newQuad(0, 64, 256, 64, 256, 128)
    },
    draw = function(s)
      G.fontSize = s.fontSize or 30 * s.h / ui_style.button.h
      --normal
      if s.disabled == true then 
        G.setColor(255, 255, 255, 128)
      end
      G.drawq(ui_style.button.image, ui_style.button.normal.quad, s.x, s.y, s.angle, s.sx, s.sy)
      --hover
      if s.hover_alpha > 0 and s.disabled == false then
        G.setColor(s.r or 255, s.g or 255, s.b or 255, (s.hover_alpha*s.a)/255)
        G.drawq(ui_style.button.image, ui_style.button.hover.quad, s.x, s.y, s.angle, s.sx, s.sy)
      end
      if s.text then
        if ui_style.button.font then G.setFont(ui_style.button.font) end
        G.setColor(255,255,255, s.a*s.a/255/2) 
        Gprintf(s.text, s.x+1, 1+s.y+(s.h - G.fontSize)/2, s.w, 'center')
        
        if ui_style.button.font_color then 
          local c = ui_style.button.font_color
          G.setColor(c[1],c[2],c[3],s.a*c[4]/255)
        end
        Gprintf(s.text, s.x, s.y+(s.h - G.fontSize)/2, s.w, 'center')
        
      end
      --G.setColor(255, 255, 255, s.a)
      --G.rectangle('line', s.x+(s.w - ui_style.button.font:getWidth(s.text))/2, s.y+(s.h - ui_style.button.font:getHeight())/2, ui_style.button.font:getWidth(s.text),ui_style.button.font:getHeight())
    end,
    mouseover = function(self)
      self:stop('hover'):animate({hover_alpha=255},{queue='hover'})
    end,
    mouseout = function(self)
      self:stop('hover'):animate({hover_alpha=0},{speed=0.6,queue='hover'})
    end
  },
  list = {
    font = G.newFont('data/fonts/ru.ttf', 25),
    w = 400, h = 28,
    draw = function(s)
      if ui_style.list.font then G.setFont(ui_style.list.font) end
      G.printf(s.text, s.x, s.y, s.w, 'left')
      G.printf(s._vars_names[s._pos], s.x, s.y, s.w, 'right')
    end,
    mouseover = function(self)
      self:stop('hover'):animate({b=120},{queue='hover'})
    end,
    mouseout = function(self)
      self:stop('hover'):animate({b=255},{speed=0.6,queue='hover'})
    end
  },
  slider = {
    image = G.newImage('data/gfx/slider-button.png'),
    button = {
      quad = G.newQuad(0, 0, 32, 32, 32, 64),
      w = 32, h=32
    },
    button_l = G.newQuad(0, 32, 10, 32, 32, 64),
    button_c = G.newQuad(10, 32, 12, 32, 32, 64),
    button_r = G.newQuad(22, 32, 10, 32, 32, 64),
    font = G.newFont('data/fonts/ru.ttf', 25),
    w = 400, h = 28,
    draw = function(s)
      if ui_style.list.font then G.setFont(ui_style.list.font) end
      G.printf(s.text, s.x, s.y, s.w, 'left')
      G.print(math.floor(var_by_reference (s._variable)), s.x+400, s.y)
      G.setColor(255,255,255,255)
      G.drawq(ui_style.slider.image, ui_style.slider.button_l, s.x+248, s.y-2)
      G.drawq(ui_style.slider.image, ui_style.slider.button_c, s.x+248+10, s.y-2, 0, 132/12, 1)
      G.drawq(ui_style.slider.image, ui_style.slider.button_r, s.x+400-10, s.y-2)
    end,
    button_draw = function(s)
      G.drawq(ui_style.slider.image, ui_style.slider.button.quad, s.x, s.y)
    end,
    mouseover = function(self)
      self:stop('hover'):animate({b=120},{queue='hover'})
    end,
    mouseout = function(self)
      self:stop('hover'):animate({b=255},{speed=0.6,queue='hover'})
    end
  },
  menu = {
    margin = 10, --space between items
    start = 120 --top indent
  }
}