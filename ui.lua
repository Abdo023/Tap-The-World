
-- Responsible for creating UI elements in the entire game

local U = {}
local widget = require( "widget" )
local u = require( "utils" )

-- To hold building btns
function U.scroll(  )
	local scrl = widget.newScrollView( {
		backgroundColor = { 34 /255, 49 /255, 63 /255 },
        width = u.sW,
        height = u.sH ,
        --scrollWidth = u.sceneW/4,
        horizontalScrollDisabled = true,
        leftPadding = 50,
        topPadding = 2
	} )
	return scrl
end

function U.normalBtn( width,height,txt,func )
	local btn = widget.newButton( {
        shape = "roundedRect",
        width = width,
        height = height,
        label = txt,
        labelAlign = "left",
        font = native.systemFont,
        labelColor = { default={ 255 /255, 255 /255, 255 /255 }, over={ 0, 0, 0, 0.5 } },
        fontSize = 32,
        strokeColor = { default={211 /255, 84 /255, 0 /255}, over={0.2,0.2,1,1} },
        strokeWidth = 2,
        fillColor = { default={211 /255, 84 /255, 0 /255, 0.1}, over={1,1,1,0.3} },
        --emboss = true,
        isEnabled = false,
        onPress = func
	} )
	return btn
end

-- The building generatig bar
function U.bar( parent, width )
	local height = 10
	local frame = display.newRect(parent, 0, 0, width, height)
	frame:setFillColor( 1,1,1 )
	frame.anchorX = 0
	frame.strokeWidth = 2

	local bar = display.newRect( parent, 0, 0, width*0.5, height )
	bar:setFillColor( 0,1,0 )
	bar.anchorX = 0
	bar.oWidth = frame.width
	bar.frame = frame

	return frame, bar
end

function U.editBar( bar, value )
	bar.cV = value
	bar.width = (bar.cV / bar.mV) * bar.oWidth
end


-- Money, Tech, Army top labels
function U.statLabel( txt )
	local textOptions = {
        --parent = sceneGroup,
        text = txt..": 0",     
        width = 200,
        font = native.systemFont,   
        fontSize = 30,
        align = "center"
    }
    local label = display.newText( textOptions )
    label:setFillColor( 0,0,0 )
    return label
end

function U.tabBar( func )
	 local tabButtons = {
    {
        label = "Business",
        id = "businessScene",
        width = 32, 
        height = 120,
        size = 30,
        selected = true,
        onPress = func
    },
    {
        label = "Tech",
        id = "techScene",
        width = 32, 
        height = 120,
        size = 30,
        onPress = func
    },
    {
        label = "Army",
        id = "armyScene",
        width = 32, 
        height = 120,
        size = 30,
        onPress = func
    }
    }
    
    local tabBar = widget.newTabBar( {
        top = u.sH - 100,
        width = u.sW,
        height = 100,
        buttons = tabButtons
    } )
    return tabBar
end


return U