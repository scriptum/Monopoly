--��������� ��� "������"
S.newThread('game/server.lua')
print('client')
local lasttime = 0

getplayerxy = function(n, k)
  side = companys._child[n].side
  x, y = get_xy(companys._child[n].pos, side)
  if side == 1 then
    x = x + math.cos(k*math.pi)*14 + 8
    y = y + k*12 - 3
  elseif side == 2 then
    x = x + k*14 - 12
    y = y + math.cos(k*math.pi)*12 + 12
  elseif side == 3 then
    x = x + math.cos(k*math.pi)*12 + 8
    y = y + k*12 - 12
  elseif side == 4 then
    x = x + k*14 -15
    y = y + math.cos(k*math.pi)*12 + 12
  else
    x = x + k*14 -15
    y = y + math.cos(k*math.pi*0.5)*30 + 24
  end
  return x + cell_padding, y + cell_padding
end

local roll = function()
  dices.ds1 = math.random(1,6)
  dices.ds2 = math.random(1,6)
end

move = function(num, ds1, ds2)
  local pl = player._child[num]
  current_player = num --��� ��� ����, ����� ������� ������� �����
  local x = ds1 + ds2
  local i = math.random(1,6)
  sound_dice[i]:play()
  local j = i 
  while i == j do j = math.random(1,6) end
  sound_dice[j]:play()
  for i = 1, 19 do
    pl:delay({speed = i/200, callback = roll})
  end
  dices.ds1 = ds1
  dices.ds2 = ds2
  pl:delay(0.5)
  if pl.jail == 0 then
    local pl_x, pl_y
    local last_cell = pl.pos
    local last_i = 1
    -- ��������� ��� ����, �� ������� ��������
    for i=1, x do
      pl.pos = pl.pos + 1
      if pl.pos > max then
	pl.pos = pl.pos-max
      end
      if table.find(angles, pl.pos) > 0 then
	pl_x, pl_y = getplayerxy(pl.pos, pl.k)
	pl:animate({x=pl_x, y=pl_y},{speed=(i + 1 - last_i)/5})
	last_cell = pl.pos
	last_i = i
      end
    end
    if pl.pos ~= last_cell then
      pl_x, pl_y = getplayerxy(pl.pos, pl.k)
      pl:animate({x=pl_x, y=pl_y},{speed=(x + 1 - last_i)/5})
    end
  end
end

set_cash = function(num, money)
  local pl = player._child[num]
  pl:delay({speed = 0, cb = function()
    pl:stop('money'):animate({cash = money}, {speed = 0.5, queue = 'money'})
  end})
end

player = E:new(board)

for k = 1, 5 do
  local   x, y = getplayerxy(1, k)
  E:new(player)
  :draw(player_draw):set{k=k, jail=0, pos=1, x=x, y=y}  
end

table.insert(lquery_hooks, function()
	--�������� ������ 20 �� - ��� ��� ����� ���������� ����� ���
	if time - lasttime > 0.02 then 
		lasttime = time
		--�������� ��������� � ����� "g"
		msg = S.recv('g')
		--������ ���� ��������� �� ���� - �����, ����� �� �������� ������� ����������
		if msg then 
			--��������� ���������� ��������� ��� ��� ������, ��������� ������
			xpcall(loadstring(msg), print)
		end
		
	end
end)