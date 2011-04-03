local meta = getmetatable("") -- get the string metatable

meta.__add = function(a,b) -- the + operator
    return a..b
end

meta.__sub = function(a,b) -- the - operator
    return a:gsub(b,"")
end

meta.__mul = function(a,b) -- the * operator
    return a:rep(b)
end