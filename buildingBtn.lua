local C = {}



function C.createBuildingBtn( parent, txt, func )
	local width = U.sW/3
	local btn = UI.normalBtn (U.sW-50, 140, txt, func)
	btn.id = 0
	btn.purchaced = false  -- In order to start generating
	local frame, bar = UI.bar(btn, btn.width)
	frame.x = 0
	bar.x = frame.x
	frame.y = btn.height - frame.height - 10
	bar.y = frame.y
	btn.frame = frame
	btn.bar = bar

	local textOptions = {
        parent = btn,
        text = "Cost: ",     
        width = 200,
        font = native.systemFont,   
        fontSize = 20,
        align = "center"
    }
    local offset = 100
    local y = 20

    local countTxt = display.newText( textOptions )
	countTxt.x = 150
	countTxt.y = btn.height*0.5
	btn.countTxt = countTxt

	local outTxt = display.newText( textOptions )
	outTxt.x = btn.width*0.5
	outTxt.y = btn.height*0.5
	btn.outTxt = outTxt

	local moneyTxt = display.newText( textOptions )
	moneyTxt.x = btn.width*0.5 - offset
	moneyTxt.y = y
	btn.moneyTxt = moneyTxt

	local techTxt = display.newText( textOptions )
	techTxt.x = btn.width*0.5
	techTxt.y = y
	btn.techTxt = techTxt

	local armyTxt = display.newText( textOptions )
	armyTxt.x = btn.width*0.5 + offset
	armyTxt.y = y
	btn.armyTxt = armyTxt

	--btn:insert( frame )
	--btn:insert( bar )
	--btn:insert( moneyTxt )

	function btn.setTxt( count, out,  money, tech, army )
		btn.countTxt.text = count
		btn.outTxt.text = out
		btn.moneyTxt.text = money
    	btn.techTxt.text = tech
    	btn.armyTxt.text = army
	end

	function btn.reset(  )
		btn.bar.width = 0
	end

	return btn

end


return C