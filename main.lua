-----------------------------------------------------------------------------------------
-- main.lua
-- just reset random and go to menu
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene( "menu", { time=800, effect="crossFade" } )
