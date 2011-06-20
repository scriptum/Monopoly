#!/usr/bin/lua

--преобразует font.fnt в уже готовый lua-файл, скорость возрастает в разы.

function string.trim(s)
  return s:gsub("^%s+", ""):gsub("%s+$", "")
end
io.output(io.open("font.lua","w"))
io.write("if not Fonts then Fonts = {} end\n")
io.write("if not FontTextures then FontTextures = {} end\n")
io.write("local d\n")
io.write("local t\n")
local img = nil
local c,x,y,cw,ch,cx,cy,w,h
local fontname, fontsize, fontsizetype
local fontdata
local ffontname, ffontsize
for line in io.lines("font.fnt") do
	if not img then 
		img = line:match("textures:(.+)")
		io.write("t = S.newImage(\"" .. img:trim() .. "\")\n")
		io.write("table.insert(FontTextures, t)\n")
	end
	c,x,y,cw,ch,cx,cy,w,h = line:match("([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)%s+([%d]+)")
	fontname, fontsize, fontsizetype = line:match("(.+)%s([%d]+)(p[tx])")
	if fontsizetype then
		if fontsizetype == "px" then fontsize = math.floor(fontsize * 72 / 96) end
		io.write("if not Fonts[\""..fontname.."\"] then Fonts[\""..fontname.."\"] = {} end\n")
		ffontname = fontname
		ffontsize = fontsize
		io.write("d = S.addFont(t)\n")
		io.write("Fonts[\""..fontname.."\"]["..fontsize.."] = d\n")
	elseif w and h then
		io.write("d:setGlyph("..c..","..x..","..y..","..cw..","..ch..","..cx..","..cy..","..w..","..h..")\n")
	end
end
io.close()
--[[
Font.get = function(name, size)
	if not Fonts[name] then return nil end
	local delta, mindeltafont, maxsizefont
	local mindelta = 99999
	local maxsize = 0
	for k, v in pairs(Fonts[name]) do
		if math.abs(k - size) < mindelta then 
			mindelta = math.abs(k - size) 
			mindeltafont = v
		end
		if v.size + 0 > maxsize then
			maxsize = v.size + 0
			maxsizefont = v
		end
	end
	if mindelta <= 1 then return mindeltafont end
	return maxsizefont
end
]]