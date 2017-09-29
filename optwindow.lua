--Used only scene:create function

-- Composer support
local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- return to Main Menu
local function gotoMenu()

	composer.gotoScene( "menu", { time=800, effect="crossFade" } )

end

-- show modal window yes/no
local function gotoReset()

	composer.showOverlay( 'ynwindow', { isModal = true } )

end

-- this function is child callback after yes/no window
function scene:checkyn()

	-- questionYesNo - true if user select yes
	if ( composer.getVariable( 'questionYesNo') == true ) then
		composer.setVariable( 'gameReset', true ) -- this variable checked in game.lua
		composer.gotoScene( "game", { time=800, effect="crossFade" } )
	end

end

-- return to Game
local function gotoGame()

	composer.gotoScene( "game", { time=800, effect="crossFade" } )

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
	local background = display.newImageRect( sceneGroup, "assets/optwindow.png", 640, 360 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

    local keyMainMenu = display.newRect( sceneGroup, display.contentCenterX, 295, 640, 50 )
    keyMainMenu.alpha = 0
    keyMainMenu.isHitTestable = true
	keyMainMenu:addEventListener( "tap", gotoMenu )

    local keyResetGame = display.newRect( sceneGroup, display.contentCenterX, 425, 640, 50 )
    keyResetGame.alpha = 0
    keyResetGame.isHitTestable = true
	keyResetGame:addEventListener( "tap", gotoReset )
	
	local keyReturn = display.newRect( sceneGroup, display.contentCenterX, 500, 640, 50 )
    keyReturn.alpha = 0
    keyReturn.isHitTestable = true
	keyReturn:addEventListener( "tap", gotoGame )

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
