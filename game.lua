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
local textTapsSpd
local textBelieve
local textLoadSpd
local textLoadTot

-------------------------------------------------------------------------------
-- Taps speed check
-------------------------------------------------------------------------------
-- Make table for check taps per last 1 second, and start index of taps
local lastTapsCount = 0
local tapsPlayerNext = 1
local tapsPlayerCheck = {}

-- Adding to table zeros for a start
for i = 1, gameLoopCycles do

    table.insert( tapsPlayerCheck, 0 )

end

-------------------------------------------------------------------------------
-- Сonfiguration files operations
-------------------------------------------------------------------------------
-- Link to config file
local configPath = system.pathForFile( "lgcconfig.json", system.DocumentsDirectory )

-- Configuration table
local configTable = {}

-- Saving configuration
local function configSave()
 
    local configFile = io.open( configPath, "w" )
 
    if configFile then
        configFile:write( json.encode( configTable ) )
        io.close( configFile )
    end

end

-- Reset and save configuration
local function configReset()
    
    configTable = { 
    	loadSpeed = 1, -- Bytes loading per second. in beginning = 1 b/s
    	tapsPlayer = 0, -- Directly players taps. in beginning = 0
    	tapsTotal = 0, -- All taps with helpers. in beginning = 0
    	believe = 1, -- Bytes give 1 taps per second. in beginning = 1 b/s
    	speedMeasure = 0, -- Helper to make easier change measure count: 0 - bytes, 8 - yotabytes
    	loadTotal = 0, -- Count of all loaded data (with helpers)
    	lastTimeSave = os.time() -- Date of last save - use to make viruses
    }
 	
 	configSave()

end

-- Load Configuration, if can't - reset
local function configLoad()
 
	local configFile = io.open( configPath, "r" )

    if configFile then

        local contents = configFile:read( "*a" )
        io.close( configFile )
        configTable = json.decode( contents )

    end
 
    if ( configTable == nil or configTable.loadTotal == nil ) then

    	configReset()

    end
    
end

-------------------------------------------------------------------------------
-- Interface windows change
-------------------------------------------------------------------------------
local function gotoShop()

    configSave()
    print('gotoShop')

end

local function gotoStats()

	configSave()
    print('gotoStats')

end

local function gotoCheats()

	configSave()
    print('gotoCheats')

end

-------------------------------------------------------------------------------
-- In-game logic
-------------------------------------------------------------------------------
-- Single Tap
local function tapSingle()
    
    configTable.tapsPlayer = configTable.tapsPlayer + 1
    configTable.loadTotal = configTable.loadTotal + configTable.believe

end

-- This function called from game loop to return actual measure in game
local function loadSpeedMeasure()

    if ( configTable.speedMeasure == 1 ) then
        return 'Kb'
    elseif ( configTable.speedMeasure == 2 ) then
        return 'Mb'
    elseif ( configTable.speedMeasure == 3 ) then
        return 'Gb'
    elseif ( configTable.speedMeasure == 4 ) then
        return 'Tb'
    elseif ( configTable.speedMeasure == 5 ) then
        return 'Pb'
    elseif ( configTable.speedMeasure == 6 ) then
        return 'Eb'
    elseif ( configTable.speedMeasure == 7 ) then
        return 'Zb'
    elseif ( configTable.speedMeasure == 8 ) then
        return 'Yb'
    end

    return 'b' -- if enter unknown return bytes

end

--Every gameLoopDelay launch function
local function gameLoop()

    if tapsPlayerNext > gameLoopCycles then

        tapsPlayerNext = 1
        
        -- Update loadTotal
        configTable.loadTotal = configTable.loadTotal + configTable.loadSpeed

    end

    -- Taps per last cycle
    tapsPlayerCheck[tapsPlayerNext] = configTable.tapsPlayer - lastTapsCount

    local tapsSpd = 0

    for i = 1, gameLoopCycles do

        tapsSpd = tapsSpd + tapsPlayerCheck[i]

    end

    tapsPlayerPrev = configTable.tapsPlayer

    textTapsSpd.text = tapsSpd
    textBelieve.text = configTable.believe .. ' ' .. loadSpeedMeasure()
    textLoadSpd.text = configTable.loadSpeed .. ' ' .. loadSpeedMeasure() .. '/s'
    textLoadTot.text = configTable.loadTotal .. ' ' .. loadSpeedMeasure()

    lastTapsCount = configTable.tapsPlayer

    -- Counting of clicks per cycle
    tapsPlayerNext = tapsPlayerNext + 1

end

-------------------------------------------------------------------------------
-- Debug: Keyboard Listener to reset game
-------------------------------------------------------------------------------

local function onKeyEvent( event )

    -- Print which key was pressed down/up
    local isSPressed = ( event.keyName == 'p' and event.phase == 'down' )

    if (  isSPressed ) then
        configReset()
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
    configLoad()

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

    textTapsSpd = display.newText( uiGroup, configTable.tapsTotal, 160, panelPosY, panelFont, 36 )
    textTapsSpd:setFillColor( 0, 0, 0 )

    textBelieve = display.newText( uiGroup, configTable.tapsTotal, 480, panelPosY, panelFont, 36 )
    textBelieve:setFillColor( 0, 0, 0 )

    textLoadSpd = display.newText( uiGroup, configTable.loadSpeed, 800, panelPosY, panelFont, 36 )
    textLoadSpd:setFillColor( 0, 0, 0 )

    textLoadTot = display.newText( uiGroup, configTable.tapsTotal, 1120, panelPosY, panelFont, 36 )
    textLoadTot:setFillColor( 0, 0, 0 )

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
    Runtime:addEventListener( "key", onKeyEvent )

    gameLoopTimer = timer.performWithDelay( gameLoopDelay, gameLoop, 0 )

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
	configSave()
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