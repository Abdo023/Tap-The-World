local composer = require( "composer" )

local scene = composer.newScene()

local widget = require ("widget")
local sb = require( "sceneBuilder")
local bBtn = require( "buildingBtn" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local runTime = 0 -- for deltaTime
local money = 0
local isDragBtnClicked = true  -- to determine the direction of the drag animation
local sections = {"Money", "Tech", "Army"}
local values = {Money=0, Tech=0, Army=0}
-- Store Buildings Data (price, name, etc) from Data lib
local bBuildings = Data.businessBuildings 
local tBuildings = Data.techBuildings
local aBuildings = Data.armyBuildings  
-- UI
local mGroup, bGroup, tGroup, aGroup  -- to hold the rect & the building btns
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
        Anims.slideAnim(targetGroup, "left", 500)
        Anims.slideAnim(currentGroup, "left", 500)
    else
        Anims.slideAnim(targetGroup, "right", 500)
        Anims.slideAnim(currentGroup, "right", 500)
    end
end

local function handleTabBarEvent( event )
    local btn = event.target  -- Reference to button's 'id' parameter
     if (btn.id == "businessScene" and currentSection == "armyScene") then
        tGroup.x = U.sW

        sectionSlide(currentGroup, bGroup)
        currentGroup = bGroup
        switchSection()
        currentSection = "businessScene"
    elseif (btn.id == "businessScene" and currentSection ~= "armyScene") then
        sectionSlide(currentGroup, bGroup)
        currentGroup = bGroup
        switchSection()
        currentSection = "businessScene"
    end

    if (btn.id == "armyScene" and currentSection == "businessScene") then
        tGroup.x = -U.sW

        sectionSlide(currentGroup, aGroup)
        currentGroup = aGroup
        switchSection()
        currentSection = "armyScene"
    elseif (btn.id == "armyScene" and currentSection ~= "businessScene") then
        sectionSlide(currentGroup, aGroup)
        currentGroup = aGroup
        switchSection()
        currentSection = "armyScene"
    end

     if (btn.id == "techScene") then

        sectionSlide(currentGroup, tGroup)
        currentGroup = tGroup
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
    --Data.addResource("money", money)
end

local function checkBuildingPrice ()
    if (currentSection == "businessScene") then
        for i=1,#bBuildings do
            if (values.Money >= bBuildings[i].money) then
                print( bBuildings[i].name.." Can be built" )
                bBtns[i]:setEnabled( true )
                bBtns[i].bar.isVisible = true
                bBtns[i].frame.isVisible = true
            end
        end
    end
   
end

function generate( btnTable, DataTable, dt )
    if (btnTable == nil) then
        print( "Empty" )
        return
    end
    for i=1,#btnTable do
        if (btnTable[i].purchased == true) then
            if (btnTable[i].bar.width >= btnTable[i].bar.oWidth) then
            btnTable[i].bar.width = 0
            addValue("Money", DataTable[i].out)
            --addMoney(DataTable[i].rev)
        end
        btnTable[i].bar.width = btnTable[i].bar.width + 1 * (DataTable[i].time / 1000) * dt
        end

    end
end

function btnPressed( event )
    local btn = event.target
    btn.purchased = true
    btn.bar.isVisible = true
    btn.frame.isVisible = true
    btn.moneyTxt.text = "Rev: "..bBuildings[btn.id].out
end

function loadSectionData( section )
    currentSection = section
end

function dragUp(  )
    local time = 500
    if (isDragBtnClicked) then
        Anims.dragUp(tapRect, U.cY, time)
        Anims.dragUp(mGroup, U.sH - 180, time)
        isDragBtnClicked = false
    else
        Anims.dragUp(tapRect, 0, time)
        Anims.dragUp(mGroup, U.cY, time)
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

    -- Creating and handling Groups
    mGroup = display.newGroup( ) -- Main group that stays in the middle
    bGroup = display.newGroup( )
    tGroup = display.newGroup( )
    aGroup = display.newGroup( )
    sceneGroup:insert( mGroup )

    mGroup:insert( bGroup )
    mGroup:insert( tGroup )
    mGroup:insert( aGroup )

    bGroup.id = 1
    tGroup.id = 2
    aGroup.id = 3

    mGroup.x = 0
    tGroup.x = U.sW
    aGroup.x = U.sW

    mGroup.y = U.cY
    bGroup.y = 0
    tGroup.y = 0
    aGroup.y = 0

    -- Create scroll views for each section
    bScrollView = sb.createScroll()
    tScrollView = sb.createScroll()
    aScrollView = sb.createScroll()

    bGroup:insert( bScrollView )
    tGroup:insert( tScrollView )
    aGroup:insert( aScrollView )

    print( "bGroup: "..bGroup.x.." "..bGroup.y)
    print( "tGroup: "..tGroup.x.." "..tGroup.y)
    print( "aGroup: "..aGroup.x.." "..aGroup.y)

    local tabBar = UI.tabBar( handleTabBarEvent )
    
    local topBox = display.newRect( U.cX, 0, U.sW, 300 )
    topBox:setFillColor( 0,0,1 )

    local x = U.sW/3
    for i=1,3 do
        local label = UI.statLabel(sections[i])
        label.x = (x*i) - (x/2)
        label.y = 100
        label.id = sections[i]
        labels[#labels+1] = label
    end

    -- The rect that handle the tabs
    tapRect = display.newRect( sceneGroup, U.cX, U.cY, U.sW, U.sH )
    tapRect:setFillColor( 1,0,0,0.5 )
    tapRect:toBack( )
    tapRect:addEventListener( "touch", touch )

    -- Btn to open/close main building btns group
    dragBtn = UI.normalBtn(U.sW/2, 40, "Buildings", dragUp)
    dragBtn:setEnabled( true )
    dragBtn.x = U.cX
    dragBtn.y = mGroup.y - (mGroup.height*0.5) - (dragBtn.height * 0.5)
    --dragBtn.y = 
    dragBtn:toFront( )
    mGroup:insert( dragBtn )

    -- Populate the buildings btns
    local btns = sb.populateBtns(bScrollView, bBuildings, bBtns, btnPressed)
    local btns = sb.populateBtns(tScrollView, tBuildings, tBtns)
    local btns = sb.populateBtns(aScrollView, aBuildings, aBtns)

    currentGroup = bGroup

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