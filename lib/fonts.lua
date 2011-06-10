function scrupp.printLines(arr, x, y, width, align)
	local h = scrupp.stringHeight()
	for i = 1,#arr do
		scrupp.print(arr[i], x, y + h * (i - 1), width, align)
	end
end