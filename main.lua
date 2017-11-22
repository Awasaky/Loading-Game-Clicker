-----------------------------------------------------------------------------------------
-- main.lua
-- just reset random and go to menu
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

-- Composer initalize
local composer = require( "composer" )

-- Go to the menu screen
composer.gotoScene( "menu", { time=800, effect="crossFade" } )
