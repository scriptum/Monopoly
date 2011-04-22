function love.conf(t)
  t.title = "Monopoly"        -- The title of the window the game is in (string)
  t.author = "Scriptum Plus"        -- The author of the game (string)
  t.identity = nil            -- The name of the save directory (string)
  t.screen.width = 800        -- The window width (number)
  t.screen.height = 600       -- The window height (number)
  t.screen.fullscreen = false -- Enable fullscreen (boolean)
  --t.screen.fsaa = 4
  t.screen.vsync = false       -- Enable vertical sync (boolean)
  t.modules.joystick = false 
  t.modules.physics = false  
end