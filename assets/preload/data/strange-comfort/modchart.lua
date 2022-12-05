-- this gets called starts when the level loads.
function start(song) -- arguments, the song name
	loadCharacter("keen-flying",100,50)
    changeDadCharacter("keen-flying",false,"dance")
	
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
	if curStep == 127 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 255 then
		changeDadCharacter("keen-flying",false,"dance")
		
	end
	if curStep == 319 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 383 then
		changeDadCharacter("keen-flying",false,"dance")
		
	end
    if curStep == 447 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 511 then
		changeDadCharacter("keen-flying",false,"dance")
	end
    if curStep == 639 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 763 then
		changeDadCharacter("keen-flying",false,"dance")
	end
    if curStep == 891 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 1023 then
		changeDadCharacter("keen-flying",false,"dance")
	end
    if curStep == 1152 then
		changeDadCharacter("beat",false,"normal")
	end
	if curStep == 1215 then
		changeDadCharacter("keen-flying",false,"dance")
	end
    if curStep == 1276 then
		changeDadCharacter("beat",false,"normal")
        syncChar("keen-flying",true,false)
	end
end

function playerOneTurn() --this executes when it's the rival's turn
	
end

function playerTwoTurn() --this executes when it's the player's turn
	
end