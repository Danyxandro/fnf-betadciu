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
	if curStep == 60 or curStep == 444 or curStep == 524 or curStep == 828 then
		if wait == 2 then
			playAnim('dad','singUP-alt') --playAnim(character [dad, bf, gf], animation) This stands for the Ugh tankman animation
		else
			wait = wait + 1
		end
	else
		wait = 0
	end
end
function beatHit (beat)
-- do nothing
end
function stepHit (step)
	
end

function spin(cam, arrows)
	camHudAngle = camHudAngle + cam
	for i=0,7 do
		setActorAngle(getActorAngle(i) + arrows, i)
	end
end