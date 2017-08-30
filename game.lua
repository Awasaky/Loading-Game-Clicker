-- -----------------------------------------------------------------------------------
--
-- In a first launch, new elements come to screen after players taps
-- In any another launch, all elements already on screen 
--
-- -----------------------------------------------------------------------------------

--Composer support
local composer = require( "composer" )
--JSON support
local json = require( "json" )

--composer utility variable
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Variables to gameloop works
local gameLoopTimer -- Use to hold timer to call gameLoop
local gameLoopDelay = 100 -- time between gameLoop calls
local gameLoopCycles = math.floor( 1000 / gameLoopDelay ) -- gameLoop cycles per second
local oneLoopUpdate = 1 / gameLoopCycles

--Screen groups
local backGroup
local mainGroup
local uiGroup

-------------------------------------------------------------------------------
-- UI
-------------------------------------------------------------------------------
-- UI text settings
local panelFont = native.newFont( "Arial Black" )
local panelPosY = 40

-- UI output text strings
local textLoadTot -- Load total moved to left side of screen
local textBelieve
local textLoadSpd
local textLoadData -- Taps counter changed to Load Data counter

-- Speed Measures
local spdMeasure = { 'b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb' }

-------------------------------------------------------------------------------
-- Сonfiguration files operations
-------------------------------------------------------------------------------
-- Configuration table
local cfg = {}

-- Link to cfg file
cfgPath = system.pathForFile( "lgccfg.json", system.DocumentsDirectory )

-- Saving cfguration
local function cfgSave ()

    local cfgFile = io.open( cfgPath, "w" )
 
    if cfgFile then

    	cfg.lastTimeSave = os.time()
        cfgFile:write( json.encode( cfg ) )
        io.close( cfgFile )

    end

end

-- load defaut data and save cfguration
local function cfgReset ()

	local cfgFile = io.open( "start.json", "r" )

    if cfgFile then

        local contents = cfgFile:read( "*a" )
        io.close( cfgFile )
        cfg = json.decode( contents )
        cfg.lastTimeSave = os.time() -- Date of last save - use to make viruses
        cfgSave()

    end

end

-- Load Configuration, if can't - reset
 local function cfgLoad()
 
	local cfgFile = io.open( cfgPath, "r" )

    if cfgFile then

        local contents = cfgFile:read( "*a" )
        io.close( cfgFile )
        cfg = json.decode( contents )

    end
 
    if ( cfg == nil or cfg.loadTotal == nil ) then

    	cfgReset()

    end
    
end

-------------------------------------------------------------------------------
-- Interface windows change
-------------------------------------------------------------------------------
local function gotoShop()

    cfgSave()
    print('gotoShop')

end

local function gotoStats()

	cfgSave()
    print('gotoStats')

end

local function gotoCheats()

	cfgSave()
    print('gotoCheats')

end

-------------------------------------------------------------------------------
-- In-game logic
-------------------------------------------------------------------------------

-- round number to base
local function roundTo( roundNumber, roundBase )

	return math.floor( roundNumber * 10 ^ roundBase + 0.5 ) * 0.1 ^ roundBase

end

-- return difference between 2 measures
local function measureDiff( measureStart, measureEnd )

	return 10 ^ ( 3 * ( measureStart - measureEnd ) )

end

local function tapSingle()
    
    cfg.tapsPlayer = cfg.tapsPlayer + 1
    cfg.tapsTotal = cfg.tapsTotal + 1
    cfg.loadTotal = cfg.loadTotal + cfg.believe * measureDiff ( cfg.believeMeasure, cfg.loadTotalMeasure )

end

--Every gameLoopDelay launch function
local function gameLoop()

	-- Update Load Total
    cfg.loadTotal = cfg.loadTotal + cfg.loadSpeed * oneLoopUpdate  * measureDiff( cfg.loadSpeedMeasure, cfg.loadTotalMeasure )

    -- Update UI
    textLoadTot.text = roundTo( cfg.loadTotal, 4 ) .. ' ' .. spdMeasure[cfg.loadTotalMeasure]
    textBelieve.text = roundTo( cfg.believe, 4 ) .. ' ' .. spdMeasure[cfg.believeMeasure]
    textLoadSpd.text = roundTo( cfg.loadSpeed, 4 ) .. ' ' .. spdMeasure[cfg.loadSpeedMeasure] .. '/s'

end

-- When any of indicators be too much big, then it be reduced and updated measure
local function measureUpdate()

    if cfg.loadTotal > 10000 then
    	cfg.loadTotalMeasure = cfg.loadTotalMeasure + 1
    	cfg.loadTotal = cfg.loadTotal * 0.001
    end

    if cfg.believe > 10000 then
    	cfg.believeMeasure = cfg.believeMeasure + 1
    	cfg.believe = cfg.believe * 0.001
    end

    if cfg.loadSpeed > 10000 then
    	cfg.loadSpeedMeasure = cfg.loadSpeedMeasure + 1
    	cfg.loadSpeed = cfg.loadSpeed * 0.001
    end

end

-------------------------------------------------------------------------------
-- Debug: Keyboard Listener to reset game
-------------------------------------------------------------------------------

local function onKeyEvent( event )

    -- Print which key was pressed down/up
    local isSPressed = ( event.keyName == 'p' and event.phase == 'down' )

    if (  isSPressed ) then
        cfgReset()
    end
 
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        local platformName = system.getInfo( "platformName" )
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
            return true
        end
    end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	
    --Load Game
    cfgLoad()

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group
 
	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group
 
	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group

	-- Load the background
    local background = display.newImageRect( backGroup, "assets/001/back.png", 1280, 720 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- top bar, centered and also all texts ready to refresh
    local topbar = display.newImageRect( backGroup, "assets/001/topbar.png", 1280, 60 )
    topbar.x = display.contentCenterX
    topbar.y = 30

    textLoadTot = display.newText( uiGroup, cfg.tapsTotal, 160, panelPosY, panelFont, 36 ) -- Loading Total moved
    textLoadTot:setFillColor( 0, 0, 0 )

    textBelieve = display.newText( uiGroup, cfg.tapsTotal, 480, panelPosY, panelFont, 36 )
    textBelieve:setFillColor( 0, 0, 0 )

    textLoadSpd = display.newText( uiGroup, cfg.loadSpeed, 800, panelPosY, panelFont, 36 )
    textLoadSpd:setFillColor( 0, 0, 0 )

    textLoadData = display.newText( uiGroup, cfg.loadData, 1120, panelPosY, panelFont, 36 )
    textLoadData:setFillColor( 0, 0, 0 )

    local shopKey = display.newImageRect( mainGroup, "assets/001/shop.png", 320, 150 )
    shopKey.x = 160
    shopKey.y = 240
    shopKey:addEventListener( "tap", gotoShop )

    local statsKey = display.newImageRect( mainGroup, "assets/001/stats.png", 320, 150 )
    statsKey.x = 160
    statsKey.y = 390
    statsKey:addEventListener( "tap", gotoStats )

    local cheatsKey = display.newImageRect( mainGroup, "assets/001/cheats.png", 320, 150 )
    cheatsKey.x = 160
    cheatsKey.y = 540
    cheatsKey:addEventListener( "tap", gotoCheats )

    local tapKey = display.newImageRect( mainGroup, "assets/001/tapkey.png", 400, 400 )
    tapKey.x = display.contentCenterX
    tapKey.y = display.contentCenterY
    tapKey:addEventListener( "tap", tapSingle )

    Runtime:addEventListener( "key", onKeyEvent ) -- to debug/ later need to be removed

    gameLoopTimer = timer.performWithDelay( gameLoopDelay, gameLoop, 0 )

    measureTimer = timer.performWithDelay( 30000, measureUpdate, 0 )

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
        timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		-- composer.removeScene( "game" )
        Runtime:removeEventListener( "key", onKeyEvent )
        composer.removeScene( "game" )
	end
end

-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	cfgSave()
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
