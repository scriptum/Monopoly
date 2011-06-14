if not Fonts then Fonts = {} end
if not FontTextures then FontTextures = {} end
local d
local t
t = G.newImage("data/fonts/font.dds")
table.insert(FontTextures, t)
if not Fonts["PT Sans Caption"] then Fonts["PT Sans Caption"] = {} end
d = scrupp.addFont(t)
Fonts["PT Sans Caption"][35] = d
d:setGlyph(32,0,0,0,0,13,61,13,61)
d:setGlyph(97,219,211,24,25,1,23,27,61)
d:setGlyph(98,220,79,25,34,3,15,29,61)
d:setGlyph(99,276,182,21,26,1,23,24,61)
d:setGlyph(100,141,81,26,34,1,15,30,61)
d:setGlyph(101,180,184,25,26,1,23,28,61)
d:setGlyph(102,487,110,20,33,0,15,20,61)
d:setGlyph(103,437,40,25,35,1,23,29,61)
d:setGlyph(104,268,148,24,33,3,15,30,61)
d:setGlyph(105,72,81,9,35,3,13,15,61)
d:setGlyph(106,0,0,12,45,0,13,15,61)
d:setGlyph(107,293,148,24,33,3,15,27,61)
d:setGlyph(108,360,76,13,34,3,15,16,61)
d:setGlyph(109,360,180,38,25,3,23,44,61)
d:setGlyph(110,269,210,24,25,3,23,30,61)
d:setGlyph(111,153,184,26,26,1,23,29,61)
d:setGlyph(112,246,79,25,34,3,23,29,61)
d:setGlyph(113,168,81,25,34,1,23,29,61)
d:setGlyph(114,438,228,16,25,3,23,19,61)
d:setGlyph(115,298,182,20,26,1,23,23,61)
d:setGlyph(116,28,187,19,31,0,18,19,61)
d:setGlyph(117,206,184,24,26,3,23,30,61)
d:setGlyph(118,89,214,27,25,0,23,27,61)
d:setGlyph(119,319,181,40,25,0,23,40,61)
d:setGlyph(120,60,216,28,25,0,23,28,61)
d:setGlyph(121,305,41,26,35,0,23,26,61)
d:setGlyph(122,462,202,22,25,1,23,25,61)
d:setGlyph(65,278,114,31,33,2,15,35,61)
d:setGlyph(66,111,150,26,33,5,15,34,61)
d:setGlyph(67,277,42,27,35,3,14,33,61)
d:setGlyph(68,82,81,29,34,5,15,37,61)
d:setGlyph(69,366,146,22,33,5,15,31,61)
d:setGlyph(70,389,145,22,33,5,15,30,61)
d:setGlyph(71,219,43,28,35,3,14,35,61)
d:setGlyph(72,400,110,28,33,5,15,37,61)
d:setGlyph(73,412,144,16,33,3,15,22,61)
d:setGlyph(74,343,77,16,34,0,15,21,61)
d:setGlyph(75,458,110,28,33,5,15,36,61)
d:setGlyph(76,342,146,23,33,5,15,30,61)
d:setGlyph(77,75,117,35,33,5,15,45,61)
d:setGlyph(78,371,111,28,33,5,15,38,61)
d:setGlyph(79,186,44,32,35,3,14,38,61)
d:setGlyph(80,191,150,25,33,5,15,33,61)
d:setGlyph(81,62,0,35,44,3,14,40,61)
d:setGlyph(82,0,153,27,33,5,15,35,61)
d:setGlyph(83,385,40,25,35,3,14,31,61)
d:setGlyph(84,341,112,29,33,2,15,33,61)
d:setGlyph(85,112,81,28,34,4,15,36,61)
d:setGlyph(86,146,116,33,33,1,15,36,61)
d:setGlyph(87,430,76,45,33,2,15,49,61)
d:setGlyph(88,213,115,32,33,2,15,36,61)
d:setGlyph(89,180,116,32,33,1,15,35,61)
d:setGlyph(90,84,151,26,33,3,15,31,61)
d:setGlyph(48,332,41,26,35,1,14,28,61)
d:setGlyph(49,318,147,23,33,2,15,28,61)
d:setGlyph(50,272,79,23,34,2,14,28,61)
d:setGlyph(51,320,77,22,34,3,15,28,61)
d:setGlyph(52,429,110,28,33,0,15,28,61)
d:setGlyph(53,296,78,23,34,2,15,28,61)
d:setGlyph(54,463,40,24,35,2,14,28,61)
d:setGlyph(55,243,149,24,33,2,15,28,61)
d:setGlyph(56,0,83,24,35,2,14,28,61)
d:setGlyph(57,359,40,25,35,1,14,28,61)
d:setGlyph(46,222,237,9,7,2,42,13,61)
d:setGlyph(44,113,240,9,14,2,41,12,61)
d:setGlyph(33,374,76,9,34,4,15,15,61)
d:setGlyph(63,50,81,21,35,1,14,23,61)
d:setGlyph(45,314,235,14,5,2,28,18,61)
d:setGlyph(43,465,228,23,22,2,22,27,61)
d:setGlyph(92,303,0,23,40,0,15,23,61)
d:setGlyph(47,327,0,22,40,0,15,22,61)
d:setGlyph(40,174,0,14,43,3,10,17,61)
d:setGlyph(41,159,0,14,43,0,10,17,61)
d:setGlyph(58,455,228,9,25,4,24,15,61)
d:setGlyph(59,48,187,10,31,3,24,14,61)
d:setGlyph(37,69,45,40,35,2,14,43,61)
d:setGlyph(38,150,45,35,35,4,14,42,61)
d:setGlyph(96,210,237,11,7,3,14,16,61)
d:setGlyph(39,176,237,7,10,4,15,13,61)
d:setGlyph(42,389,232,16,15,2,13,19,61)
d:setGlyph(35,89,185,27,28,0,18,28,61)
d:setGlyph(36,226,0,24,42,2,11,28,61)
d:setGlyph(61,89,240,23,14,2,26,27,61)
d:setGlyph(91,146,0,12,44,3,10,16,61)
d:setGlyph(93,132,0,13,44,1,10,16,61)
d:setGlyph(64,13,0,48,44,5,11,58,61)
d:setGlyph(94,406,232,23,14,1,15,25,61)
d:setGlyph(123,98,0,16,44,2,10,19,61)
d:setGlyph(125,115,0,16,44,1,10,19,61)
d:setGlyph(95,290,236,23,5,0,53,23,61)
d:setGlyph(126,184,237,25,9,1,26,27,61)
d:setGlyph(34,161,237,14,10,4,15,20,61)
d:setGlyph(62,438,202,23,25,2,20,27,61)
d:setGlyph(60,169,211,24,25,1,20,27,61)
d:setGlyph(150,265,236,24,5,5,28,34,61)
d:setGlyph(151,232,237,32,5,5,28,42,61)
d:setGlyph(171,366,232,22,21,1,20,25,61)
d:setGlyph(187,342,233,23,21,1,20,25,61)
d:setGlyph(147,123,237,18,12,1,10,20,61)
d:setGlyph(148,142,237,18,12,1,15,20,61)
d:setGlyph(124,462,0,6,39,3,15,12,61)
d:setGlyph(224,219,211,24,25,1,23,27,61)
d:setGlyph(225,0,46,26,36,1,13,29,61)
d:setGlyph(226,366,206,23,25,3,23,27,61)
d:setGlyph(227,485,202,18,25,3,23,21,61)
d:setGlyph(228,469,144,30,31,0,23,31,61)
d:setGlyph(229,180,184,25,26,1,23,28,61)
d:setGlyph(184,411,40,25,35,1,14,28,61)
d:setGlyph(230,399,179,38,25,0,23,38,61)
d:setGlyph(231,254,183,21,26,1,23,23,61)
d:setGlyph(232,194,211,24,25,3,23,30,61)
d:setGlyph(233,25,83,24,35,3,13,30,61)
d:setGlyph(234,244,210,24,25,3,23,27,61)
d:setGlyph(235,143,211,25,25,0,23,28,61)
d:setGlyph(236,0,219,30,25,3,23,36,61)
d:setGlyph(237,294,209,23,25,3,23,29,61)
d:setGlyph(238,153,184,26,26,1,23,29,61)
d:setGlyph(239,318,209,23,25,3,23,29,61)
d:setGlyph(240,246,79,25,34,3,23,29,61)
d:setGlyph(241,276,182,21,26,1,23,24,61)
d:setGlyph(242,342,207,23,25,0,23,23,61)
d:setGlyph(243,305,41,26,35,0,23,26,61)
d:setGlyph(244,189,0,36,42,1,15,38,61)
d:setGlyph(245,60,216,28,25,0,23,28,61)
d:setGlyph(246,0,187,27,31,3,23,30,61)
d:setGlyph(247,390,206,23,25,1,23,27,61)
d:setGlyph(248,438,176,35,25,3,23,41,61)
d:setGlyph(249,429,144,39,31,3,23,43,61)
d:setGlyph(250,31,219,28,25,0,23,29,61)
d:setGlyph(251,474,176,32,25,3,23,38,61)
d:setGlyph(252,414,205,23,25,3,23,26,61)
d:setGlyph(253,231,183,22,26,1,23,25,61)
d:setGlyph(254,117,184,35,26,3,23,40,61)
d:setGlyph(255,117,211,25,25,0,23,28,61)
d:setGlyph(192,278,114,31,33,2,15,35,61)
d:setGlyph(193,165,150,25,33,5,15,33,61)
d:setGlyph(194,111,150,26,33,5,15,34,61)
d:setGlyph(195,488,37,21,33,5,15,28,61)
d:setGlyph(196,394,0,35,39,2,15,39,61)
d:setGlyph(197,366,146,22,33,5,15,31,61)
d:setGlyph(168,280,0,22,41,5,7,31,61)
d:setGlyph(198,384,76,45,33,1,15,48,61)
d:setGlyph(199,194,80,25,34,2,15,31,61)
d:setGlyph(200,476,76,28,33,5,15,38,61)
d:setGlyph(201,251,0,28,41,5,7,38,61)
d:setGlyph(202,458,110,28,33,5,15,36,61)
d:setGlyph(203,310,113,30,33,1,15,36,61)
d:setGlyph(204,75,117,35,33,5,15,45,61)
d:setGlyph(205,400,110,28,33,5,15,37,61)
d:setGlyph(206,186,44,32,35,3,14,38,61)
d:setGlyph(207,28,153,27,33,5,15,37,61)
d:setGlyph(208,191,150,25,33,5,15,33,61)
d:setGlyph(209,277,42,27,35,3,14,33,61)
d:setGlyph(210,341,112,29,33,2,15,33,61)
d:setGlyph(211,246,114,31,33,1,15,34,61)
d:setGlyph(212,110,45,39,35,3,14,45,61)
d:setGlyph(213,213,115,32,33,2,15,36,61)
d:setGlyph(215,138,150,26,33,4,15,35,61)
d:setGlyph(214,430,0,31,39,5,15,39,61)
d:setGlyph(216,0,119,38,33,5,15,48,61)
d:setGlyph(217,350,0,43,39,5,15,51,61)
d:setGlyph(218,111,116,34,33,1,15,38,61)
d:setGlyph(219,39,119,35,33,5,15,45,61)
d:setGlyph(220,217,149,25,33,5,15,33,61)
d:setGlyph(221,248,43,28,35,2,14,33,61)
d:setGlyph(222,27,45,41,35,5,14,50,61)
d:setGlyph(223,56,153,27,33,2,15,33,61)
d:setGlyph(169,469,0,38,36,2,17,42,61)
d:setGlyph(174,59,187,29,28,3,13,35,61)