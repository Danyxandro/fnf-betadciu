local Ypos = {}
local mainCamAngle = 0

function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	if getDifficulty() ~= 0 then
		if (curStep >= 535 and curStep <= 545) or (curStep >= 1303 and curStep <= 1313) then
			spin(174.9 / fpsCap)
		end
		if (curStep >= 1044 and curStep <= 1054) then
			spin(-174.9 / fpsCap)
		end
	end
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if (getDifficulty() ~= 0) then
		if step==546 or step==1314 then
			camHudAngle = 180
		end
		if step == 535 or step==1303 then
		print("swap")
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..(7-i)..'X'] + 32, Ypos[i], 1)
				tweenStrumAngle(i, 180, 1)
			end
		end
		if step==1044 then
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..i..'X'], Ypos[i], 1)
				tweenStrumAngle(i, 0, 1)
			end
		end
		if step==1055 then
			camHudAngle = mainCamAngle
			for i=0,7 do
				setActorAngle(0, i)
			end
		end
	end
	if step==1846 then
		for i=0,7 do
			tweenFadeOut(i, 0, 1)
		end
	end
	if step==1856 then --untwist camera
		for i=0,7 do
			tweenPos(i, _G['defaultStrum'..i..'X'], Ypos[i], 0.1)
			setActorAngle(0, i)
		end
		camHudAngle = mainCamAngle
	end
end

function spin(cam)
	camHudAngle = camHudAngle + cam
end
