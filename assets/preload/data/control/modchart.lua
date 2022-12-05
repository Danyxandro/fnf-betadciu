local Ypos = {}
local mainCamAngle = 0
local flag = 0
local camY = 0

function start (song)
	print("modchart added")
	for i=0,7 do
		Ypos[i] = _G['defaultStrum'..i..'Y']
	end
	mainCamAngle = camHudAngle
	camY = getHudY();
end

function update (elapsed)
	--[[if curStep>=420 and curStep <= 430 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()+1.8)
		else
			setHudPosition(getHudX(), getHudY()-1.8)
		end
	end
	if curStep>=548 and curStep <= 553 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()-1.3)
		else
			setHudPosition(getHudX(), getHudY()+1.3)
		end
	end]]
end
function beatHit (beat)
	
end
function stepHit (step)
	if step==420 then
		if downscroll == 0 then
			--setHudPosition(getHudX(), camY + 206)
			tweenHudPos(getHudX(), camY + 206, 0.75)
		else
			--setHudPosition(getHudX(), camY - 206)
			tweenHudPos(getHudX(), camY - 206, 0.75)
		end
	end
	if step==548 then
		--[[if downscroll == 0 then
			setHudPosition(getHudX(), camY)
		else
			setHudPosition(getHudX(), camY)
		end]]
		tweenHudPos(getHudX(), camY, 0.6)
	end
end