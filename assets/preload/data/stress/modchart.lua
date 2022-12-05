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
	if curStep == 737 then
		playAnim('dad','prettygood') --playAnim(character [dad, bf, gf], animation) This stands for the pretty good tankman animation
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