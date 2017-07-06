local composer = require( "composer" )

local scene = composer.newScene()

local widget = require ("widget")
local u = require( "utils")
local anims = require( "animations")
local sb = require( "sceneBuilder")
local ui = require( "ui" )
local bBtn = require( "buildingBtn" )
local data = require( "data" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local runTime = 0 -- for deltaTime
local money = 0
local isDragBtnClicked = false  -- to determine the direction of the drag animation
local sections = {"Money", "Tech", "Army"}
local values = {money=0, tech=0, army=0}
local bBuildings = data.businessBuildings  -- Store Buildings data (price, name, etc) from data lib
local tBuildings = data.techBuildings
local aBuildings = data.armyBuildings  
-- UI
local btnsGroup  -- to hold the rect & the building btns
local tapRect -- the area where the player taps
local dragBtn    -- the btn which will move the group
local moneyLabel, techLabel, armyLabel
local bBtns, tBtns, aBtns = {}, {}, {}
local purchasedBtns = {}

local currentSection = "businessScene"


local function handleTabBarEvent( event )
    local btn = event.target  -- Reference to button's 'id' parameter
     if (btn.id == "businessScene") then
        composer.gotoScene( event.target.id, "slideRight" )
        currentScene = "businessScene"
    elseif (btn.id == "armyScene") then
        composer.gotoScene( event.target.id, "slideLeft" )
        currentScene = "armyScene"
    elseif (btn.id == "techScene" and currentScene == "businessScene") then
        composer.gotoScene( event.target.id, "slideLeft" )
        currentScene = "techScene"
    elseif (btn.id == "techScene" and event.target.id == "armyScene") then
        composer.gotoScene( event.target.id, "slideRight")
        currentScene = "techScene"
    end
    
end

local function addValue (key, amount)
    values[key] = values[key] + amount
    print( values[key]  )
    --moneyLabel.text = "Money: "..money
    --data.addResource("money", money)
end

local function tap( event )
    if (currentSection == "businessScene") then
        addValue("money", 1)
    elseif (currentSection == "techScene") then
        addValue("tech", 1)
    elseif (currentSection == "armyScene") then
        addValue("army", 1)
    end
    --checkBuildingPrice ()
end

local function checkBuildingPrice ()
    for i=1,#bBuildings do
        if (money >= bBuildings[i].price) then
            print( bBuildings[i].name.." Can be built" )
            bBtns[i]:setEnabled( true )
            bBtns[i].bar.isVisible = true
            bBtns[i].frame.isVisible = true
        end
    end
end

function generate( btnTable, dataTable, dt )
    if (btnTable == nil) then
        print( "Empty" )
        return
    end
    for i=1,#btnTable do
        if (btnTable[i].purchased == true) then
            if (btnTable[i].bar.width >= btnTable[i].bar.oWidth) then
            btnTable[i].bar.width = 0
            addMoney(dataTable[i].rev)
        end
        btnTable[i].bar.width = btnTable[i].bar.width + 1 * (dataTable[i].time / 1000) * dt
        end

    end
end

function btnPressed( event )
    local btn = event.target
    btn.purchased = true
    btn.moneyTxt.text = "Rev: "..bBuildings[btn.id].rev
end

function loadSectionData( section )
    currentSection = section
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

-- For animating the bars and generating the money
function enterFrame( event )
    local dt = getDT()
    generate(bBtns, bBuildings, dt)
    generate(tBtns, tBuildings, dt)
    generate(aBtns, aBuildings, dt)
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

   local tabBar = ui.tabBar( handleTabBarEvent )
    
    local topBox = display.newRect( u.cX, 0, u.sW, 300 )
    topBox:setFillColor( 0,0,1 )

    local x = u.sW/3
    for i=1,3 do
        local label = ui.statLabel(sections[i])
        label.x = (x*i) - (x/2)
        label.y = 100
    end

    tapRect = display.newRect( sceneGroup, u.cX, u.cY, u.sW, u.sH )
    tapRect:setFillColor( 1,0,0,0.5 )
    tapRect:toBack( )
    tapRect:addEventListener( "tap", tap )
    
    --composer.gotoScene( "businessScene" )
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