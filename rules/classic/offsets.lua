offset_logo = {
	{ --top
		w = cw - cell_padding * 2, --width
		x = cell_padding,          --x offset inside cell
		y = 0                      --y offset inside cell
	},
	{ --right
		w = cw - cell_padding * 2 - 5,
		x = ch - cw + cell_padding * 2,
		y = cell_padding - 5
	},
	{ --bottom
		w = cw - cell_padding * 2,
		x = cell_padding,
		y = ch - cw + cell_padding * 2
	},
	{ --left
		w = cw - cell_padding * 2 - 5,
		x = cell_padding * 2,
		y = cell_padding - 5
	}
}

local w = math.min(cw, (ch - cw))
offset_group = {
	{ --top
		w = w,
		x = (cw - w - cell_padding * 2) / 2,
		y = cw + fnt_small:height() - cell_padding * 2
	},
	{ --right
		w = w,
		x = (ch - cw - w) / 2,
		y = (cw + a - w) / 2
	},
	{ --bottom
		w = w,
		x = (cw - w - cell_padding * 2) / 2,
		y = ch - cw - fnt_small:height() + cell_padding * 2 - w * 0.8
	},
	{ --left
		w = w,
		x = cw + (ch - cw - w) / 2,
		y = (cw + a - w) / 2
	}
}

offset_rent_color = {0, 0, 0}
offset_rent = {
	{ --top
		w = cw,
		size = 11,
		x = 0, 
		y = cw - cell_padding * 2
	},
	{ --right
		w = cw,
		size = 11,
		x = ch - cw, 
		y = cw - 12
	},
	{ --bottom
		w = cw,
		size = 11,
		x = 0, 
		y = ch - cw + cell_padding -4
	},
	{ --left
		w = cw,
		size = 11,
		x = 0, 
		y = cw - 12
	}
}


offset_chest = offset_logo

offset_chest_text = {
	{ --top
		w = cw,
		size = 15,
		x = 0, 
		y = cw + 3
	},
	{ --right
		w = cw,
		size = 11,
		x = ch - cw, 
		y = cw - 12
	},
	{ --bottom
		w = cw,
		size = 15,
		x = 0, 
		y = ch - cw - 15
	},
	{ --left
		w = cw,
		size = 11,
		x = 0, 
		y = cw - 12
	}
}