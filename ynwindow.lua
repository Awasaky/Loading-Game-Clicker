-- Used scene events: create and hide+will also 2 functions created before show scene


-- Composer support
local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Clean composer variable to check what a key pressed in modal window
composer.setVariable( 'questionYesNo', false )

function gotoYes()

	composer.setVariable( 'questionYesNo', true )
	composer.hideOverlay()

end

function gotoNo()

	composer.hideOverlay()

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "assets/ynwindow.png", 512, 128 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- Invisible rectangle to press Yes or No

    local keyYes = display.newRect( sceneGroup, display.contentCenterX - 116, display.contentCenterY + 36 , 256, 64 )
    keyYes.alpha = 0
    keyYes.isHitTestable = true
	keyYes:addEventListener( "tap", gotoYes )

    local keyNo = display.newRect( sceneGroup, display.contentCenterX + 134, display.contentCenterY + 36, 256, 64 )
    keyNo.alpha = 0
    keyNo.isHitTestable = true
	keyNo:addEventListener( "tap", gotoNo )

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
	local parent = event.parent  -- Reference to the parent scene object

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		
		----------------------------------------------
		-- Calls checkyn function inside Parent scene
		----------------------------------------------
		parent:checkyn()

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
