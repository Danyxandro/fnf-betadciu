local Ypos = {}
local camY = 0
local mainCamAngle = 0
function start (song)
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
	camY = getHudY()
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	if(getDifficulty() ~= 0) then
		if curStep >= 512 and curStep <= 522 then --flip camera
			spin(174.9 / fpsCap)
		end
		if (curStep >= 778 and curStep <= 783) then --unflip
			spin(-330 / fpsCap)
		end
	end
	if curStep >= 784 and curStep <= 1039 then
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
	end
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if step == 1040 then
		for i=0,3 do
			tweenFadeIn(i, 0, 1)
		end
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'], i)
		end
	end
	if step==1289 then
		for i=4,7 do
			tweenFadeOut(i, 0, 1)
		end
	end
	if(getDifficulty() ~= 0) then
		if step == 512 then --twist strums
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..(7-i)..'X'] + 32, Ypos[i], 1)
				tweenStrumAngle(i, 180, 1)
			end
		end
		if step==523 then --twist camera
			camHudAngle = 180
		end
		if step == 778 then --untwist strums
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..i..'X'], Ypos[i], 0.3)
				tweenStrumAngle(i, 0, 0.3)
			end
		end
		if step==784 then --untwist camera
			camHudAngle = mainCamAngle
		end
	end
end

function spin(cam)
	camHudAngle = camHudAngle + cam
end