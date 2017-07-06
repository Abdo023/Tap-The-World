
-- Hold the different variables and unlocks of the app.

local D = {}

D.currentMoney = 0
D.currentTech = 0
D.currentArmy = 0

 D.businessBuildings = {
	{name="Shop", price=2, rev=3, time=2000},
	{name="Stand", price=11, rev=4, time=1000}
}

 D.techBuildings = {
	{name="Lab", price=10, rev=2, time=5000},
	{name="Plant", price=11, rev=2, time=5000}
}

 D.armyBuildings = {
	{name="Barracks", price=10, rev=2, time=5000},
	{name="Missle Factory", price=11, rev=2, time=5000}
}

D.addResource = function ( name, value ) 
	if (name == "money") then
		D.currentMoney = D.currentMoney + value
	elseif (name == "tech") then
		D.currentTech = D.currentTech + value
	elseif (name == "army") then
		D.currentArmy = D.currentArmy + value
	end
end




return D