while true do
	scrupp.delay(1)
	if(math.random(0,1000) == 0) then
		scrupp.send("1", "2")
	end
end