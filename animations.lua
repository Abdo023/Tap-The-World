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
		local options = {
			x= -obj.width*2,
			time= time,
		}
		transition.to (obj, options)
	end

	function right(  )
		local options = {
			x= obj.width*2,
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