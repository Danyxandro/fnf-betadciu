local Ypos = {}
local mainCamAngle = 0
local text = "text"
local space = "spaceBG"

function start (song)
	print("modchart added")
	print("Cam size: "..hudWidth..","..hudHeight)
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
	makeSprite("outerspace",space, true)
	setActorX(100, space)
	setActorY(600, space)
	setActorScale(3, space)
	setActorAlpha(0, space)
	makeSprite("nothingImpossible",text, false)
	setActorX(-10, text)
	setActorY(300, text)
	setActorScale(2.08, text)
	setScrollFactor(0,0,text)
	setActorAlpha(0, text)
end

function update (elapsed)
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if curStep==928 then
		tweenFadeOut(space, 1, 1)
	end
	if curStep==928 then
		setDefaultCamZoom("0.5")
	end
	if curStep==1103 then
		for i=0,3 do
			tweenFadeOut(i,0,3)
		end
		tweenFadeOut(text, 1, 3)
	end
	if curStep==1136 then
		for i=4,7 do
			tweenFadeOut(i, 0, 1.5)
		end
		showOnlyStrums = true
	end
end

function spin(cam, arrows)
	camHudAngle = camHudAngle + cam
	for i=0,7 do
		setActorAngle(getActorAngle(i) + arrows, i)
	end
end