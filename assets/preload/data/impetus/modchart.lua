local Ypos = {}
local Xpos = {}
local mainCamAngle = 0
local texts = {"you"}
local drain = 0.01
function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
		Xpos[i] = _G['defaultStrum'..i..'X']
		setActorX(Xpos[i], i)
	end
	for i=0,3 do
		setActorX(Xpos[i+4], i)
	end
	for i=4,7 do
		setActorX(Xpos[i-4], i)
	end
	mainCamAngle = camHudAngle
	addImages()
	if getHealthValue("good") == 0 then
		drain = 0.008 - getHealthValue("sick") 
	end
end

function update (elapsed)
	
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if step == 48 then
		print('cambio')
		changeNoteStyle('pixel')
	end
	if curStep == 80 then
		tweenFadeIn(texts[1],0,5)
	end
end

function spin(cam, arrows)
	camHudAngle = camHudAngle + cam
	for i=0,7 do
		setActorAngle(getActorAngle(i) + arrows, i)
	end
end

function addImages()
	makeSprite("you",texts[1],false)
	setActorScale(1.8,texts[1])
	setScrollFactor(0,0,texts[1])
	setActorX(-140,texts[1])
	if downscroll == 0 then
		setActorY(130,texts[1])
	else
		setActorY(578,texts[1])
	end
	--setActorY(130,texts[1])
end

function playerTwoSing(direction, pos, type, isSustain)
	if (type == 0 or type == 5) and not isSustain and getHealth() >= 0.08 then
		heal(drain)
	end
end

function playerOneSing(direction, pos, type, isSustain)
	if (type == 0 or type == 5) and isSustain then
		heal(0.005)
	end
end