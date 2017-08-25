
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoAbout()
	composer.gotoScene( "about", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	local background = display.newImageRect( sceneGroup, "menu/background.png", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImageRect( sceneGroup, "menu/title.png", 652, 94 )
	title.x = display.contentCenterX - 250
	title.y = display.contentCenterY + 300

	local buttonPlay = display.newImageRect( sceneGroup, "menu/buttonPlay.png", 348, 102 )
	buttonPlay.x = 1050
	buttonPlay.y = 100
	
	local buttonAbout = display.newImageRect( sceneGroup, "menu/buttonAbout.png", 348, 102 )
	buttonAbout.x = 1050
	buttonAbout.y = 220
	
	buttonPlay:addEventListener( "tap", gotoGame )
	buttonAbout:addEventListener( "tap", gotoAbout )

	---------------------------------------
	-- delete after final objects layout --
	---------------------------------------
	composer.gotoScene( "game" )
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
