return {
  button = {
    image = G.newImage('data/gfx/menu-button.png'),
    font = G.newFont('data/fonts/ru.ttf', 32),
    font_color = {0,0,0,255},
    w = 256, h = 64,
    normal = {
      quad = G.newQuad(0, 0, 256, 64, 256, 128)
    },
    hover = {
      quad = G.newQuad(0, 64, 256, 64, 256, 128)
    },
    draw = function(s)
      --normal
      G.drawq(ui_style.button.image, ui_style.button.normal.quad, s.x, s.y, s.angle, s.sx, s.sy)
      --hover
      if s.hover_alpha > 0 then
        G.setColor(s.r or 255, s.g or 255, s.b or 255, (s.hover_alpha*s.a)/255)
        G.drawq(ui_style.button.image, ui_style.button.hover.quad, s.x, s.y, s.angle, s.sx, s.sy)
      end
      if s.text then
        if ui_style.button.font then G.setFont(ui_style.button.font) end
        G.setColor(255,255,255, s.a*s.a/255/2) 
        G.printf(s.text, s.x+1, 1+s.y+(s.h - ui_style.button.font:getHeight())/2, s.w, 'center')
        
        if ui_style.button.font_color then 
          local c = ui_style.button.font_color
          G.setColor(c[1],c[2],c[3],s.a*c[4]/255)
        end
        G.printf(s.text, s.x, s.y+(s.h - ui_style.button.font:getHeight())/2, s.w, 'center')
        
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
      G.printf(s._vars[var_by_reference(s._variable)], s.x, s.y, s.w, 'right')
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
    start = 30 --top indent
  }
}