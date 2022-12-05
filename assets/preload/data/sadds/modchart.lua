local Ypos = {}
local Xpos = {}
local CamY = 0
local spid = 0
local red = "redEffect"
function start (song)
	spid = scrollspeed
	print("modchart added Sadds")
	print(spid)
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
		Xpos[i] = _G['defaultStrum'..i..'X']
		setActorX(Xpos[i], i)
	end
	if getDifficulty() == 1 then
		setActorX(Xpos[1], 0)
		setActorX(Xpos[2], 3)
		setActorX(Xpos[5], 4)
		setActorX(Xpos[6], 7)
	end
	if getDifficulty() == 2 then
		for i=0,3 do
			setActorX(Xpos[1] + 50, i)
		end
		for i=4,7 do
			setActorX(Xpos[5] + 50, i)
		end
	end
	alterStyle("dance",0)
	if getDifficulty() ~= 0 then
		setGhostTapping(0)
	end
	addImages()
	CamY = getHudY()
end

function update (elapsed)
	
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if step == 381 then
		for i=0,7 do
			tweenPos(i, Xpos[i], getActorY(i), 1)
		end
		setGhostTapping(2)
		changeSpeed(spid + 0.6)
		alterStyle("cat",0)
		tweenFadeOut(red,0,2)
	end
	if getDifficulty() ~= 0 then
		if step == 890 then
			changeSpeed(spid)
			if downscroll == 0 then
				tweenHudPos(getHudX(), CamY + 228, 1)
			else
				tweenHudPos(getHudX(), CamY - 228, 1)
			end
		end
		if step == 1136 then
			changeSpeed(spid + 0.6)
			tweenHudPos(getHudX(), CamY, 0.75)
		end
	end
end

function alterStyle(style,mode)
	if getDifficulty() ~= 0 then
		if style == "dance" then
			if getDifficulty() == 1 then
				changeNoteStyle("dance2",mode)
			end
			if getDifficulty() == 2 then
				changeNoteStyle("dance3",mode)
			end
		else
			changeNoteStyle(style,mode)
		end
	end
end

function addImages()
	makeSprite("danger",red,false)
	setActorScale(2,red)
	setScrollFactor(0,0,red)
	setActorX(0,red)
	setActorY(230,red)
end