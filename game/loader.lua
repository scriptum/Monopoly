local loadimg = scrupp.newImage('data/gfx/load.dds')
loadimg:draw(0,0,0,1024, 768)
scrupp.swapBuffers()
local progress = scrupp.newImage('data/gfx/progress.png')
local progress2 = scrupp.newImage('data/gfx/progress2.png')
local s = {x = 200, y = 550, w = 624, h = 90, _image = progress, orig_w = 128, orig_h = 128, top = 34, left = 34, right= 34, bottom = 34}
local percent = 0
function loader(p)
	percent = percent + p
	if percent > 100 then percent = 100 end
	loadimg:draw(0,0,0,1024, 768)
	s._image = progress2
	s.w = math.floor(34*2 + 1 + (624 - 34 * 2 - 1) / 100 * percent)
	lQuery.border_image_draw(s)
	s._image = progress
	s.w = 624
	lQuery.border_image_draw(s)
	scrupp.swapBuffers()
end