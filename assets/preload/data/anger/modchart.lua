local Ypos = {}
local Xpos = {}
local CamY = 0
local red = "redEffect"
local texts = {"you","are","not","aMan"}
function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
		Xpos[i] = _G['defaultStrum'..i..'X']
	end
	CamY = getHudY()
	if getDifficulty() ~= 0 then
		changeNoteStyle('cat')
	end
	addImages()
end

function update (elapsed)
	
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	songScript()
end

function songScript()
	letters()
	if curStep == 184 then
		alterColumns(1, true, 0.75)
	end
	if curStep == 191 then
		alterColumns(2, true, 0.75)
	end
	if curStep == 696 then
		alterColumns(0, false, 0.75)
	end
	if curStep == 960 then
		alterColumns(2, true, 0.5)
	end
	if curStep == 1143 then
		alterColumns(2, false, 0.5)
	end
	if curStep == 1207 then
		alterColumns(2, true, 0.5)
	end
	if curStep == 1271 then
		alterColumns(2, false, 0.5)
	end
	if curStep == 1472 then
		alterColumns(0, true, 0.5)
	end
	if curStep == 1592 then
		alterColumns(1, false, 0.75)
	end
	if curStep == 1727 then
		alterColumns(3, false, 0.45)
	end
	if curStep == 1984 then
		alterColumns(0, true, 0.5)
	end
	if curStep == 2112 then
		showOnlyStrums = true
		strumLine1Visible = false
		strumLine2Visible = false
		tweenFadeIn(red,0,2)
	end
end

function alterColumns(indicator, center, time)
	if (indicator ~= 1 and indicator ~= 2 and indicator ~= 3) then
		if not center then
			for i=0,7 do
				tweenPos(i, Xpos[i], getActorY(i), time)
			end
			setGhostTapping(2)
			tweenFadeIn(red,0,2)
			alterStyle("cat",0)
		else
			if getDifficulty() == 1 then
				tweenPos(0, Xpos[1], getActorY(0), time)
				tweenPos(3, Xpos[2], getActorY(3), time)
				tweenPos(4, Xpos[5], getActorY(4), time)
				tweenPos(7, Xpos[6], getActorY(7), time)
				setGhostTapping(0)
				tweenFadeOut(red,1,2)
			end
			if getDifficulty() == 2 then
				for i=0,3 do
					tweenPos(i, Xpos[1] + 50, getActorY(i), time)
				end
				for i=4,7 do
					tweenPos(i, Xpos[5] + 50, getActorY(i), time)
				end
				setGhostTapping(0)
				tweenFadeOut(red,1,2)
			end
			alterStyle("dance",0)
		end
	else
		if indicator == 1 then
			if not center then
				for i=0,3 do
					tweenPos(i, Xpos[i], getActorY(i), time)
				end
				alterStyle("cat",2)
			else
				if getDifficulty() == 1 then
					tweenPos(0, Xpos[1], getActorY(0), time)
					tweenPos(3, Xpos[2], getActorY(3), time)
				end
				if getDifficulty() == 2 then
					for i=0,3 do
						tweenPos(i, Xpos[1] + 50, getActorY(i), time)
					end
				end
				alterStyle("dance",2)
			end
		end
		if indicator == 2 or indicator == 3 then
			if not center then
				for i=4,7 do
					tweenPos(i, Xpos[i], getActorY(i), time)
				end
				setGhostTapping(2)
				if indicator == 2 then
					tweenFadeIn(red,0,2)
				end
				alterStyle("cat",1)
			else
				if getDifficulty() == 1 then
					tweenPos(4, Xpos[5], getActorY(4), time)
					tweenPos(7, Xpos[6], getActorY(7), time)
					setGhostTapping(0)
					if indicator == 2 then
						tweenFadeOut(red,1,2)
					end
				end
				if getDifficulty() == 2 then
					for i=4,7 do
						tweenPos(i, Xpos[5] + 50, getActorY(i), time)
					end
					setGhostTapping(0)
					if indicator == 2 then
						tweenFadeOut(red,1,2)
					end
				end
				alterStyle("dance",1)
			end
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
	makeSprite("thefunnyeffect",red,false)
	setActorScale(1.4,red)
	setScrollFactor(0,0,red)
	setActorX(0,red)
	setActorY(130,red)
	setActorAlpha(0,red)
	makeSprite("you",texts[1],false)
	setActorScale(1.8,texts[1])
	setScrollFactor(0,0,texts[1])
	setActorX(30,texts[1])
	setActorY(270,texts[1])
	setActorAlpha(0,texts[1])
	makeSprite("are",texts[2],false)
	setActorScale(1.8,texts[2])
	setScrollFactor(0,0,texts[2])
	setActorX(530,texts[2])
	setActorY(270,texts[2])
	setActorAlpha(0,texts[2])
	makeSprite("not",texts[3],false)
	setActorScale(1.8,texts[3])
	setScrollFactor(0,0,texts[3])
	setActorX(1030,texts[3])
	setActorY(270,texts[3])
	setActorAlpha(0,texts[3])
	makeSprite("a man",texts[4],false)
	setActorScale(1.8,texts[4])
	setScrollFactor(0,0,texts[4])
	setActorX(490,texts[4])
	setActorY(530,texts[4])
	setActorAlpha(0,texts[4])
end

function letters()
	if curStep == 1676 then
		tweenFadeIn(texts[1],1,2)
	end
	if curStep == 1681 then
		tweenFadeIn(texts[2],1,2)
	end
	if curStep == 1688 then
		tweenFadeIn(texts[3],1,2)
	end
	if curStep == 1702 then
		tweenFadeIn(texts[4],1,1.5)
	end
	if curStep == 1752 then
		for j=1,4 do
			tweenFadeOut(texts[j],0,3)
		end
	end
end