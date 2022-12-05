local Ypos = {}
local camY = 0
local camX = 0
local mainCamAngle = 0

function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
	camY = getHudY()
	camX= getHudX()
	bpm = 160
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	if (getDifficulty() ~= 0) then
		if (curStep >= 801 and curStep <= 806) then
			spin(330 / fpsCap)
		end
		if (curStep >= 1877 and curStep <= 1887) then
			spin(174.9 / fpsCap)
		end
	end
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	if (getDifficulty() ~= 0) then
		if step==807 or step==1888 then --twist camera
			camHudAngle = 180
		end
		if step == 801 then --twist strums
			print("swap")
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..(7-i)..'X'] + 32, Ypos[i], 0.3)
				tweenStrumAngle(i, 180, 0.3)
			end
		end
		if step==1877 then --twist strums
			print("swap")
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..(7-i)..'X'] + 32, Ypos[i], 1)
				tweenStrumAngle(i, 180, 1)
			end
		end
		if step==1056 then --untwist camera
			for i=0,7 do
				tweenPos(i, _G['defaultStrum'..i..'X'], Ypos[i], 0.1)
				tweenStrumAngle(i, 0, 0.1)
			end
			camHudAngle = mainCamAngle
		end
		
	end
	if step==1350 then --move strums at 1361
		if downscroll == 0 then
			tweenHudPos(getHudX(), camY + 228, 0.75)
		else
			tweenHudPos(getHudX(), camY - 228, 0.75)
		end
	end
	if step==1608 then --put strums back at 1608
		tweenHudPos(camX, camY, 0.75)
	end
	
	if step==2132 then
		for i=0,7 do
			tweenFadeOut(i, 0, 1)
		end
	end
	if step==2154 then --untwist camera
		for i=0,7 do
			tweenPos(i, _G['defaultStrum'..i..'X'], Ypos[i], 0.1)
			tweenStrumAngle(i, 0, 0.1)
		end
		camHudAngle = mainCamAngle
	end
end

function spin(cam)
	camHudAngle = camHudAngle + cam
end