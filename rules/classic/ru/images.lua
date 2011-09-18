--предварительная загрузка картинок с компаниями в память
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
  table.insert(rules_company_images, S.newImage('rules/classic/'..lang..'/logos/'..k..'.png'))
  if k % 10 == 0 then loader(5) end
end
--предварительная загрузка картинок с группами в память
rules_group_images = {}
for k, v in pairs(rules_group) do 
  if v.image then
    rules_group_images[k] = S.newImage('rules/classic/icons/'..v.image)
    loader(1)
  end
end