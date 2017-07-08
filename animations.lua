local A = {}
local u = require( "utils" )

function A.dragUp( obj, y, time )
	local options = {
		y=y,
		time=time
	}
 	transition.to( obj, options )
 end 


function A.slideAnim( obj, dir, time )
	
	function left( ... )
		local x
		if (obj.x > u.cX) then
			x = u.cX
		else
			x= -obj.width*0.5
		end

		local options = {
		
			x=x,
			time= time,
		}
		transition.to (obj, options)
	end

	function right(  )
		local x
		if (obj.x < u.cX) then
			x = u.cX
		else
			x= u.sW + (obj.width*0.5)
		end

		local options = {
			x= x,
			time= time,
		}
		transition.to (obj, options)
	end

	if (dir == "right") then
		right()
	else
		left()
	end
end

return A