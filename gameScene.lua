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

--Global Variables
MONEY, TECH, ARMY = 0, 0, 0

local runTime = 0 -- for deltaTime
local money = 0
local isDragBtnClicked = true  -- to determine the direction of the drag animation
local sections = {"Money", "Tech", "Army"}
local values = {Money=0, Tech=0, Army=0}
-- Store Buildings data (price, name, etc) from data lib
local bBuildings = data.businessBuildings 
local tBuildings = data.techBuildings
local aBuildings = data.armyBuildings  
-- UI
local bGroup, tGroup, aGroup  -- to hold the rect & the building btns
local bScrollView, tScrollView, aScrollView
local tapRect -- the area where the player taps
local dragBtn    -- the btn which will move the group
local labels = {}
local bBtns, tBtns, aBtns = {}, {}, {}
local purchasedBtns = {}

local currentSection = "businessScene"
local currentGroup = {}

-- Functions
local function getDT (  )
    local temp = system.getTimer( )
    local dt = (temp-runTime) / (1000/60)
    runTime = temp
    return dt
end

local function switchSection(  )
    
end

local function sectionSlide( currentGroup, targetGroup )
    if (targetGroup.id == currentGroup.id) then
        return
    elseif (targetGroup.id > currentGroup.id) then
        anims.slideAnim(targetGroup, "left", 500)
        anims.slideAnim(currentGroup, "left", 500)
    else
        anims.slideAnim(targetGroup, "right", 500)
        anims.slideAnim(currentGroup, "right", 500)
    end
end

local function handleTabBarEvent( event )
    local btn = event.target  -- Reference to button's 'id' parameter
     if (btn.id == "businessScene" and currentSection == "armyScene") then
        --tGroup.x = u.sW
        tScrollView.x = u.sW + tScrollView.width*0.5

        sectionSlide(currentGroup, bScrollView)
        currentGroup = bScrollView
        switchSection()
        currentSection = "businessScene"
    elseif (btn.id == "businessScene" and currentSection ~= "armyScene") then
        sectionSlide(currentGroup, bScrollView)
        currentGroup = bScrollView
        switchSection()
        currentSection = "businessScene"
    end

    if (btn.id == "armyScene" and currentSection == "businessScene") then
        --tGroup.x = -u.sW
        tScrollView.x = -tScrollView.width*0.5

        sectionSlide(currentGroup, aScrollView)
        currentGroup = aScrollView
        switchSection()
        currentSection = "armyScene"
    elseif (btn.id == "armyScene" and currentSection ~= "businessScene") then
        sectionSlide(currentGroup, aScrollView)
        currentGroup = aScrollView
        switchSection()
        currentSection = "armyScene"
    end

     if (btn.id == "techScene") then

        sectionSlide(currentGroup, tScrollView)
        currentGroup = tScrollView
        switchSection()
        currentSection = "techScene"
    end
    
end

local function addValue (key, amount)
    values[key] = values[key] + amount
    -- Update Label
    for i=1,#labels do
        if (labels[i].id == key) then
            labels[i].text = sections[i]..": "..values[key]
        end
    end
    --data.addResource("money", money)
end

local function checkBuildingPrice ()
    if (currentSection == "businessScene") then
        for i=1,#bBuildings do
            if (values.Money >= bBuildings[i].price) then
                print( bBuildings[i].name.." Can be built" )
                bBtns[i]:setEnabled( true )
                bBtns[i].bar.isVisible = true
                bBtns[i].frame.isVisible = true
            end
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
            addValue("Money", dataTable[i].rev)
            --addMoney(dataTable[i].rev)
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
        anims.dragUp(bGroup, u.sH - 180, time)
        isDragBtnClicked = false
    else
        anims.dragUp(tapRect, 0, time)
        anims.dragUp(bGroup, u.cY, time)
        isDragBtnClicked = true
    end
end

local function touch( event )
    if (event.phase == "ended") then
        if (currentSection == "businessScene") then
        addValue("Money", 1)
    elseif (currentSection == "techScene") then
        addValue("Tech", 1)
    elseif (currentSection == "armyScene") then
        addValue("Army", 1)
    end
    checkBuildingPrice ()
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

    bGroup = display.newGroup( )
    tGroup = display.newGroup( )
    aGroup = display.newGroup( )
    sceneGroup:insert( bGroup )
    sceneGroup:insert( tGroup )
    sceneGroup:insert( aGroup )

    bGroup.id = 1
    tGroup.id = 2
    aGroup.id = 3

    tGroup.x = u.sW
    aGroup.x = u.sW
    --print( tGroup.x )
    --print( aGroup.x  )
    --bGroup.y = u.sH - 180
    --tGroup.y = u.sH - 180
    --aGroup.y = u.sH - 180
    bGroup.y = u.cY
    tGroup.y = u.cY
    aGroup.y = u.cY


    local tabBar = ui.tabBar( handleTabBarEvent )
    
    local topBox = display.newRect( u.cX, 0, u.sW, 300 )
    topBox:setFillColor( 0,0,1 )

    local x = u.sW/3
    for i=1,3 do
        local label = ui.statLabel(sections[i])
        label.x = (x*i) - (x/2)
        label.y = 100
        label.id = sections[i]
        labels[#labels+1] = label
    end

    tapRect = display.newRect( sceneGroup, u.cX, u.cY, u.sW, u.sH )
    tapRect:setFillColor( 1,0,0,0.5 )
    tapRect:toBack( )
    tapRect:addEventListener( "touch", touch )

    -- Create scroll views for each section
    bScrollView = sb.createScroll()
    tScrollView = sb.createScroll()
    aScrollView = sb.createScroll()
    bScrollView.x = u.cX
    tScrollView.x = u.sW + tScrollView.width*0.5
    aScrollView.x = u.sW + aScrollView.width*0.5
    bScrollView.id = 1
    tScrollView.id = 2
    aScrollView.id = 3
    bGroup:insert( bScrollView )
    bGroup:insert( tScrollView )
    bGroup:insert( aScrollView )
    --tGroup:insert( tScrollView )
    --aGroup:insert( aScrollView )
    
    dragBtn = ui.normalBtn(u.sW/2, 40, "Buildings", dragUp)
    dragBtn:setEnabled( true )
    dragBtn.x = u.cX
    dragBtn.y = bGroup.y - (bGroup.height*0.5) - (dragBtn.height * 0.5)
    --dragBtn.y = 
    dragBtn:toFront( )
    bGroup:insert( dragBtn )
    print( "Group: "..bGroup.y )
    print( "Drag: "..dragBtn.x.." "..dragBtn.y )

    -- Populate the buildings btns
    local btns = sb.populateBtns(bScrollView, bBuildings, bBtns)
    local btns = sb.populateBtns(tScrollView, tBuildings, tBtns)
    local btns = sb.populateBtns(aScrollView, aBuildings, aBtns)
    --composer.gotoScene( "businessScene" )

    currentGroup = bScrollView

    Runtime:addEventListener( "enterFrame", enterFrame )
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