--предварительная загрузка картинок с игроками в память
rules_player_images = {}
for k, v in pairs(rules_player_img) do 
  table.insert(rules_player_images, S.newImage('data/gfx/player/'..v))
end

--акции
action = S.newImage('rules/classic/icons/document.dds')
all_actions = S.newImage('rules/classic/icons/briefcase.dds')