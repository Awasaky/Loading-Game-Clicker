-- This scene is underconsruction

local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local usedFont = native.newFont( "Arial Black" )

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

	-- Background same as Menu
	local background = display.newImageRect( sceneGroup, "menu/background.png", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	-- "Tap anywhere" text
	local tapAnywhere = display.newText( {
	    parent = sceneGroup,
	    text = 'tap anywhere to return to game',
	    x = display.contentCenterX-200,
	    y = 690,
	    font = usedFont,   
	    fontSize = 36
	} )
    tapAnywhere:setFillColor( 0, 0, 0 )

    -- Invisible key return to menu
    local keyReturn = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, 1280, 720 )
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
