-----------------------------------------------------------------------------------------
--
-- utils.lua
--
-----------------------------------------------------------------------------------------
local M = {}

local mSqrt = math.sqrt
local mRand = math.random

 M.cX  = display.contentCenterX
 M.cY  = display.contentCenterY

 M.sW   = display.actualContentWidth
 M.sH    = display.actualContentHeight
 M.left     = M.cX - M.sW * 0.5
 M.right    = M.cX + M.sW * 0.5
 M.top      = M.cY - M.sH * 0.5
 M.bottom   = M.cY + M.sH * 0.5

M.getDistance = function ( obj1, obj2 )
	local factor = {
		x = obj2.x - obj1.x,
		y = obj2.y - obj1.y
	}
	return mSqrt((factor.x * factor.x) + (factor.y * factor.y))
end

M.getYDistance = function ( y1, y2 )
	local factor = {
		y = y2 - y1
	}
	return mSqrt(factor.y * factor.y)
end

M.getRandom = function ( x, y )			
	local v1, v2 = x, y
	local r = mRand(0, 1)
	if (r == 1) then
		return v1
	else
		return v2
	end
end

return M