print('server')
require 'rules.classic.ru.rules' --����������� �������
require 'rules.classic.action' --��� ������ ����, �����
local S = scrupp
local send = S.send
local delay = S.delay

--������� ����
local games = {}
games['newgame'] = {}
local current_game = games['newgame']

current_game.players = {} --�� ������� ���� ������
--������ ������ �����
local cell_count = field_width * 2 + field_height * 2 + 4

local roll = function()
  local ds1, ds2 = 0
  math.randomseed(os.time() + math.random(99999))
  ds1 = math.random(1, 6)
  math.randomseed(os.time() + math.random(99999))
  ds2 = math.random(1, 6)
  return ds1, ds2
end

send('max = '..cell_count .. ' angles = {1, '..field_width..' + 2, '..field_width..' + '..field_height..' + 3, '..field_width..' * 2 + '..field_height..' + 4}', 'g')

local msg = ''
--������� �������
local i
for i = 1, 5 do
	table.insert(current_game.players, {
		pos = 1, 
		jail = 0, 
		ingame = true, 
		cash = 1500, 
		name = "", --���
		address = "", --�������� (�� � ������ �� �����)
		uid = 0 --������� ����� ����� ���-�� ������, �� ������ ������ ������ ���������
	})
	msg = msg .. 'player._child['..i..'].ingame = true '
end
send(msg, 'g')

--������� ������ ��������
current_game.companys = {}
for i = 1, cell_count do
	table.insert(current_game.companys, {})
end

current_game.double = 1 --����� ��������� ������ � ���� ����
current_game.current_player = 1 --������� �����
local __max = 5 --����������� ��������� ����� ������� �� �������
local gogo = function()
  local __i = current_game.current_player --������� �����
  local buf = current_game.players[__i]
  if buf.ingame == false or (buf.jail == 4 and current_game.double > 1) then 
    double = 1
    current_game.current_player = __i + 1
    if current_game.current_player > __max then current_game.current_player = 1 end
    gogo()
  else
    local msg = '' --���������, ������� ����� ���������� �������
    local ds1, ds2 = roll() --������� ������
    --���� ����� ������ ����� - �������� ��� �����
    if buf.pos + ds1 + ds2 > cell_count then
      msg = msg .. ' money_transfer(200, '.. __i ..')'
    end
    --�������� ������ � �������� ������� �� ��������
    msg = msg .. ' move('..__i..','..ds1..','..ds2..')'
    send(msg, 'g')
    --����� ���� ���� ��������
    delay((ds1+ds2)*200 + 2000)
    current_game.current_player = __i + 1
    if current_game.current_player > __max then current_game.current_player = 1 end
  end  
end

local done = false
while done == false do
	--send('burn:animate({a = '..math.random(50, 100)..'})', 'g')
	gogo()
	delay(20) --�� �������� ����
end