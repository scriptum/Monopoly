--действия при выходе из игры

function love.quit()
  --table_print(statistics)
  F.write('options.lua', serialize(gameoptions))
end