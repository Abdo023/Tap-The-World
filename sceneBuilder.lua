-- Contains the functions that build each of the 3 scenes
local C = {}

local bBtn = require( "buildingBtn")

function C.createScroll(  )
	local scrollView = UI.scroll()
    scrollView.y = U.cY
    return scrollView
end

-- populates building btns
function C.populateBtns ( scroll, dataTable, btnTable, func )
    tempTable = dataTable
    local createdBtns = {}  -- Returns the created btns
    local x = U.cX
    local offset = 20
    for i=1, #tempTable do
        local btn = bBtn.createBuildingBtn (scroll, tempTable[i].name, func)
        btn.setTxt( "Count: "..tempTable[i].count, "Out: $"..tempTable[i].out.."/"..(tempTable[i].time/1000).."s", "Money: "..tempTable[i].money, "Tech: "..tempTable[i].tech, "Army: "..tempTable[i].army ) -- change the money text
        btn.id = i -- for accessing the data table later
        local y = btn.height*0.5

        btn.x = U.cX
        btn.y = i * btn.height + offset
        btn.bar.width = 0
        -- Starting them not shown until player unlocks the btn
        btn.bar.isVisible = false
        btn.frame.isVisible = false

        scroll:insert( btn )
        btnTable[#btnTable+1] = btn
        offset = offset + 20

        createdBtns[#createdBtns+1] = btn
    end
    return createdBtns
end





return C