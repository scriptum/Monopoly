package.cpath = "./?.so;./?.dll;bin/?.so;bin/?.dll"
local http = require("socket.http")
local img = http.request("http://scriptumplus.ru/images/scriptum.png")
scrupp.send(img, "img")
while true do
	scrupp.delay(1)
	if(math.random(0,1000) == 0) then
		scrupp.send("1", "2")
	end
end