local Ypos = {}
local mainCamAngle = 0
local flag = 1
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
	--[[if curStep>=295 and curStep <= 300 then --206 desired pos
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()+2.8)
		else
			setHudPosition(getHudX(), getHudY()-2.8)
		end
	end
	if curStep>=343 and curStep <= 348 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()-1.4)
		else
			setHudPosition(getHudX(), getHudY()+1.4)
		end
	end
	if curStep>=440 and curStep <= 450 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()+1.9)
		else
			setHudPosition(getHudX(), getHudY()-1.9)
		end
	end
	if curStep>=483 and curStep <= 488 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()-1.9)
		else
			setHudPosition(getHudX(), getHudY()+1.9)
		end
	end
	if curStep>=604 and curStep <= 614 then --206 desired pos
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()+1.9)
		else
			setHudPosition(getHudX(), getHudY()-1.9)
		end
	end
	if curStep>=664 and curStep <= 669 then
		if downscroll == 0 then
			setHudPosition(getHudX(), getHudY()-1.8)
		else
			setHudPosition(getHudX(), getHudY()+1.8)
		end
	end]]
end
function beatHit (beat)
	if curStep >= 868 and curStep < 992 then
		if flag == 1 then
			shakeCam(0.002,0.25)
			flag = 0
		else
			flag = 1
		end
	end
end
function stepHit (step)
	if step==295 or step == 604 or step == 440 then
		if downscroll == 0 then
			--setHudPosition(getHudX(), camY + 206)
			tweenHudPos(getHudX(), camY + 206, 0.75)
		else
			--setHudPosition(getHudX(), camY - 206)
			tweenHudPos(getHudX(), camY - 206, 0.75)
		end
	end
	if step==343 or step == 664 or step == 483 then
		--[[if downscroll == 0 then
			setHudPosition(getHudX(), camY)
		else
			setHudPosition(getHudX(), camY)
		end]]
		tweenHudPos(getHudX(), camY, 0.75)
	end
end