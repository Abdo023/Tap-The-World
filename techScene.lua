local composer = require( "composer" )

local scene = composer.newScene()

local widget = require ("widget")
local u = require( "Utils")
local sb = require( "sceneBuilder")
local ui = require( "ui" )
local anims = require( "animations")
local data = require( "data" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Variables
local tech = 0
local isDragBtnClicked = false
local tBuildings = data.techBuildings 
-- UI
local moneyLabel
local tBtns = {}
local dragBtn 

local function addMoney ()
    tech = tech + 1
    moneyLabel.text = "Tech: "..tech
    data.addResource("tech", tech)
end

local function tap( event )
    addMoney()
end

function dragUp(  )
    local time = 500
    if (isDragBtnClicked) then
        anims.dragUp(tapRect, u.cY, time)
        anims.dragUp(btnsGroup, u.sH - 180, time)
        isDragBtnClicked = false
    else
        anims.dragUp(tapRect, 0, time)
        anims.dragUp(btnsGroup, u.cY, time)
        isDragBtnClicked = true
    end
end

function timerTest(  )
    timer.performWithDelay( 1000, function() print( "Test" ) end, 0 )
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    btnsGroup = display.newGroup( )
    sceneGroup:insert( btnsGroup )

    local scrollView = sb.createScroll()
    btnsGroup:insert( scrollView )

    dragBtn = ui.normalBtn(u.sW/2, 40, "Buildings", dragUp)
    dragBtn:setEnabled( true )
    dragBtn.x = u.cX
    dragBtn.y = scrollView.y - (scrollView.height*0.5) - (dragBtn.height * 0.5)
    btnsGroup:insert( dragBtn )

    btnsGroup.y = u.sH - 180

    local btns = sb.populateBtns(scrollView, tBuildings, tBtns)
    --timerTest()
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene