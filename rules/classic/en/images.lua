--предварительная загрузка картинок с компаниями в память
rules_company_images = {}
--load images
for k, v in pairs(rules_company) do
	table.insert(rules_company_images, cheetah.newImage('rules/classic/'..lang..'/logos/'..k..'.dds'))
end

--предварительная загрузка картинок с группами в память
rules_group_images = {}
for k, v in pairs(rules_group) do 
	if v.image then
		rules_group_images[k] = cheetah.newImage('rules/classic/icons/'..v.image)
	end
end
