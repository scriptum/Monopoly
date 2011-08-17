print('server')
require 'rules.classic.action' --��� ������ ����, �����
require 'rules.classic.ru.rules' --����������� �������
require 'game.ai' --������������� ���������
require 'game.actions' --�������� ������
local S = scrupp
local send = function ()
  S.send(msg, 'g')
  msg = ''
end
local delay = S.delay



--������� ����
local games = {}
games['newgame'] = {}
current_game = games['newgame']

current_game.players = {} --�� ������� ���� ������
--������ ������ �����
cell_count = field_width * 2 + field_height * 2 + 4

--����� �� �������
dice1, dice2 = 1, 1
local roll = function()
  --local ds1, ds2 = 0
  math.randomseed(os.time() + math.random(99999))
  dice1 = math.random(1, 6)
  math.randomseed(os.time() + math.random(99999))
  dice2 = math.random(1, 6)
  --return ds1, ds2
end

msg = 'max = '..cell_count .. ' angles = {1, '..field_width..' + 2, '..field_width..' + '..field_height..' + 3, '..field_width..' * 2 + '..field_height..' + 4}'
send()

msg_add = function(a,b,c,d,e,f,g)
  local arg={a,b,c,d,e,f,g}
  for k, v in ipairs(arg) do
    if k == 1 then 
      msg = msg .. ' ' .. v .. '('
    elseif v then
      if type(v)  == 'string' then v = "'" .. v .. "'" end
      if k == 2 then
	msg = msg .. v
      else
	msg = msg .. ',' .. v
      end
    end
  end
  msg = msg .. ')'
end

--������� �������
local i
for i = 1, 2 do
	table.insert(current_game.players, {
		k = i,
		pos = 1, 
		jail = 0, 
		ingame = true, 
		cash = 1500, 
		name = "", --���
		address = "", --�������� (�� � ������ �� �����)
		uid = 0 --������� ����� ����� ���-�� ������, �� ������ ������ ������ ���������
	})
	msg = msg .. ' players._child['..i..'].ingame = true'
	msg_add('set_cash', i, 1500)
end
send(msg, 'g')

--������� ������ ��������
current_game.companys = {}
for i = 1, cell_count do
	table.insert(current_game.companys, {level = 1})
end

current_game.double = 1 --����� ��������� ������ � ���� ����
current_game.current_player = 1 --������� �����
__max = 5 --����������� ��������� ����� ������� �� �������

--*******************************************GO-GO*******************************************--

gogo = function()
  local __i = current_game.current_player --������� �����
  local buf = current_game.players[__i]
  if not buf or buf.ingame == false or (buf.jail == 4 and current_game.double > 1) then 
    double = 1
    current_game.current_player = __i + 1
    if current_game.current_player > __max then current_game.current_player = 1 end
    gogo()
  else
    roll() --������� ������
    local add_money = false
    --���� ����� ������ ����� - �������� ��� �����
    buf.pos = buf.pos + dice1 + dice2
    if buf.pos > cell_count then
      buf.pos = buf.pos - cell_count
      add_money = true
    end
    --�������� ������ � �������� ������� �� ��������
    msg_add('move',__i,dice1,dice2)
    send()
    --����� ���� ���� ��������
    delay((dice1+dice2)*200 + 2000)
    if add_money == true then
      buf.cash = buf.cash + 200 --��������� ����� �� ��������� �����
      msg_add('set_cash',__i,buf.cash) --���������� ����� ��������� ����� ��������
    end
    local cell = rules_company[buf.pos]
    if cell.action then cell.action(buf.k) end
    ai(buf.k)
--    msg = msg .. ' set_cash('..__i..','..math.random(0,1500)..')'
--    msg = msg .. ' money_transfer('..math.random(-15,15)..','..__i..')'
    send()
    
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
