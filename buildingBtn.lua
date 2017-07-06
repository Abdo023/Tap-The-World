local B = {}

local utils = require( "utils" )
local ui = require( "ui" )

B.new = function ( parent, txt, func )
	local width = 300
	local btn = ui.normalBtn (utils.sW-50, 80, txt, func)
	btn.id = 0
	btn.purchaced = false  -- In order to start generating
	local frame, bar = ui.bar(parent)
	frame.x, bar.x = utils.cX, utils.cX
	frame.y, bar.y = btn.height*0.5, btn.height*0.5
	btn.frame = frame
	btn.bar = bar

	local textOptions = {
        parent = sceneGroup,
        text = "Cost: ",     
        width = 400,
        font = native.systemFont,   
        fontSize = 20,
        align = "center"
    }
	local moneyTxt = display.newText( textOptions )
	moneyTxt.x = utils.cX - 120
	moneyTxt.y = btn.height*0.5
	btn.moneyTxt = moneyTxt

	btn:insert( frame )
	btn:insert( bar )
	btn:insert( moneyTxt )

function btn.reset(  )
	btn.bar.width = 0

end

return btn
end




return B