local lastmove = nil
local nothing = nil
local function displayBoard(board)
	local b = board
	print(string.format(
	[[ 
	%s|%s|%s
	%s|%s|%s
	%s|%s|%s
	]],
	b["A1"], b['A2'], b['A3'], b['B1'] ,b['B2'], b['B3'], b['C1'], b['C2'] , b['C3'] ))
end

local function checkVictory(board)
	local hope = false
	local winConditions = { -- There has got to be a better way but fuck that lmao
		['Horizontal A'] = {"A1","A2","A3"}, -- Horizontal
		['Horizontal B'] =  {"B1","B2","B3"},
		['Horizontal C'] = {"C1","C2","C3"},
		['Vertical 1']   = {"A1","B1","C1"}, -- Vertical
		['Vertical 2']   = {"A2","B2","C2"},
		['Vertical 3']   = {"A3","B3","C3"},
		['Diagonal A1']  = {"A1","B2","C3"}, -- Diagonal
		['Diagonal A3']  = {"A3","B2","C1"}
	}
	-- loop through each position on the board and copy it into the format of win conditions
	for pos,value in next, board do 
		for ii,condition in next, winConditions do
			for iii,third in next, condition do
				if pos == third then
					condition[iii] = value
				end
			end
		end
	end
	-- check if any of the win conditions are completely filled out by "X" or "O"
	for i,condition in next, winConditions do
		if condition[1] ~= " " and condition [1] == condition[2] and condition[1] == condition[3] then
			return condition[1] -- returning the winner :) 
		else
			local x, o, blank = false, false,false
			for ii = 1,3 do
				if condition[ii] == "O" then
					o = true
				elseif condition[ii] == "X" then
					x = true
				elseif condition[ii] == " " then
					blank = true
				end
			end
			if ((not x and o) or (not o and x)) and blank then
				hope = true
			end
		end
	end

	if not hope then
		return "draw"
	else
		return nil
	end
end

local function playerMove(greeting,team,board)
	local b = board
	print("------------------------")
	displayBoard(board)
	if lastmove then
		print("Mr.Robot:",lastmove)
	end
	print(string.format("%s (%s's)",greeting,team))
	local input = string.upper(io.read())
	if board[input] then
		if board[input] == " " then
			board[input] = team
		else 
			playerMove("Spot Already Occupied: Try Again!",team,b)
		end
	else
		playerMove("Invalid Input: Try Again!",team,b)
	end
end

local function numToPos(n)
	local b = {"A1","A2","A3","B1","B2","B3","C1","C2","C3"}
	return b[n]
end

local function posToNum(s)
	local b = {"A1","A2","A3","B1","B2","B3","C1","C2","C3"}
	for n = 1,9 do
		if b[n] == s then
			return n
		end
	end
end

local function computerMove(team,difficulty,board) 
	local move
	----
	----
	----
	if difficulty == 1 then
		while true do
			local r = numToPos(math.random(9))
			if board[r] and board[r] == " " then
				print("Dumb AI trying...")
				board[r] = team 
				move = r 
				break
			end
		end
	----
	----
	----
	end
	print(move)
	return move
end


local function game(difficulty) --
	print('Launching match!')
	local board = { -- tictactoe board
		["A1"] = " ", ["A2"] = " ", ["A3"] = " ",
		["B1"] = " ", ["B2"] = " ", ["B3"] = " ",
		["C1"] = " ", ["C2"] = " ", ["C3"] = " ",
	}

	local winner = nil
	local turnCount = 0  
	lastmove = nil
	while winner == nil do
		--Player1
		turnCount = turnCount + 1
		--playerMove(turnCount == 1 and "Player1 goes First!" or "Player1's Turn!","X",board)
		lastmove = computerMove("X",difficulty,board)
		--Check Win Condition and break if won
		winner = checkVictory(board)
		if winnner == nil then 
			--Player2
			if difficulty > 0 then
				lastmove = computerMove("O",difficulty,board)
			else
				playerMove(turnCount == 1 and "Player2 goes Second!" or "Player2's Turn!","O",board)
			end
			--Check Win Conditions
			winner = checkVictory(board)
		end
		print("------------------------")
		displayBoard(board)
		print(turnCount, winner)
	end
	print("------------------------")
	displayBoard(board)
	print("Match finished!")
	if winner == "draw" then 
		print(">Draw!")
	else
		print(">"..winner.." won!")
	end
end

local function evaluateInput(string)
	return not (string == "N" or string == "No" or string == "n" or string == "NO")
end

local wantsToPlay = true
local difficulty = 0
print([[------------------------
	Tic Tac Toe 
	By Adam Zawierucha
------------------------]])
print("Want to play against a Computer?")
local computer = evaluateInput(io.read())
if computer then
	print("How hard do you want the computer to be? 1-3")
	difficulty = tonumber(io.read())
	while not difficulty or difficulty < 1 or difficulty > 3 do
		print("Invalid Input!")
		difficulty =  tonumber(io.read())
	end
end

while wantsToPlay do
	game(difficulty)
	print("------------------------")
	print("Still want to play?")
	wantsToPlay = evaluateInput(io.read())
end
