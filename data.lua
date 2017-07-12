
-- Hold the different variables and unlocks of the app.

local D = {}

D.currentMoney = 0
D.currentTech = 0
D.currentArmy = 0

 D.businessBuildings = {
	{name="Shop", count=0, money=2, tech=0, army=0, out=3, time=2000},
	{name="Stand", count=0, money=10, tech=0, army=0, out=3, time=1000}
}

 D.techBuildings = {
	{name="Lab", count=0, money=10, tech=0, army=0, out=3, time=5000},
	{name="Plant", count=0, money=10, tech=0, army=0, out=3, time=5000}
}

 D.armyBuildings = {
	{name="Barracks", count=0, money=10, tech=0, army=0, out=3, time=5000},
	{name="Missle Factory", count=0, money=10, tech=0, army=0, out=3, time=5000}
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