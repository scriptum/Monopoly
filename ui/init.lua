var_by_reference = function(var, value)
	if type(var) == 'table' then
		if #var == 1 then
			if value then _G[var[1]] = value else return _G[var[1]] end
		elseif #var == 2 then
			if value then _G[var[1]][var[2]] = value else return _G[var[1]][var[2]] end
		elseif #var == 3 then
			if value then _G[var[1]][var[2]][var[3]] = value else return _G[var[1]][var[2]][var[3]] end
		end
	else
		if value then _G[var] = value else return _G[var] end
	end
end

ui_style = require('ui.style')
