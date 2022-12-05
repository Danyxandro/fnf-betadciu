-- this gets called starts when the level loads.
function start(song) -- arguments, the song name
	loadCharacter("keen-flying",100,50)	
	visibleChar("keen-flying",true,false)
end

-- this gets called every frame
function update(elapsed) -- arguments, how long it took to complete a frame
	
end

-- this gets called every beat
function beatHit(beat) -- arguments, the current beat of the song

end

-- this gets called every step
function stepHit(step) -- arguments, the current step of the song (4 steps are in a beat)
	checkDad()
end

function checkDad()
	if curStep == 384 then
		changeDadCharacter("keen-flying",false,"dance")
	end
	if curStep == 640 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 928 then
		changeDadCharacter("keen-flying",false,"dance")
		
	end
    if curStep == 1184 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 1424 then
		changeDadCharacter("keen-flying",false,"dance")
	end
    if curStep == 1680 then
		changeDadCharacter("beat",false,"normal")
	end
end

function playerOneTurn() --this executes when it's the rival's turn
	
end

function playerTwoTurn() --this executes when it's the player's turn
	
end