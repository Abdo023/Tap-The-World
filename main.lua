-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
display.setStatusBar( display.HiddenStatusBar )


-- Global Variables
U = require("utils")
UI = require( "ui")
Anims = require( "animations")
Data = require( "data" )

local composer = require( "composer" )
composer.gotoScene( "gameScene" )