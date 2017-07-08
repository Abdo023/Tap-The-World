-- Contains the functions that build each of the 3 scenes
local Class = {}

local u = require( "utils")
local ui = require( "ui")
local data = require( "data")

function Class.createScroll(  )
	local scrollView = ui.scroll()
    scrollView.y = u.cY
    return scrollView
end



-- populates building btns
function Class.populateBtns ( scroll, dataTable, btnTable )
    tempTable = dataTable
    local createdBtns = {}  -- Returns the created btns
    local x = u.cX
    local offset = 20
    for i=1, #tempTable do
        local btn = ui.bBtn(scroll, tempTable[i].name, btnPressed)
        btn.moneyTxt.text = "Cost: "..tempTable[i].price -- change the money text
        btn.id = i -- for accessing the data table later
        local y = btn.height*0.5

        btn.x = u.cX
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


return Class