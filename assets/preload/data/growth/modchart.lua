local Ypos = {}
local mainCamAngle = 0
local flag = 1

function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
end

function update (elapsed)
	
end
function beatHit (beat)
	if curStep >= 912 and curStep < 1040 then
		if flag == 1 then
			shakeCam(0.002,0.25)
			flag = 0
		else
			flag = 1
		end
	end
end
function stepHit (step)
	
end

function spin(cam, arrows)
	camHudAngle = camHudAngle + cam
	for i=0,7 do
		setActorAngle(getActorAngle(i) + arrows, i)
	end
end