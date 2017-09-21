-- -----------------------------------------------------------------------------------
--
-- In a first launch, new elements come to screen after players taps
-- In any another launch, all elements already on screen 
--
-- -----------------------------------------------------------------------------------

-- Load and Save module
local LoadSave = require( "loadsave" )

-- Composer support
local composer = require( "composer" )

-- Сomposer utility variable
local scene = composer.newScene()

-- JSON support
local json = require( "json" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initial random
math.randomseed( os.time() )

-- Variables to gameloop works
local gameLoopTimer -- Use to hold timer to call gameLoop
local gameLoopDelay = 100 -- time between gameLoop calls
local gameLoopCycles = math.floor( 1000 / gameLoopDelay ) -- gameLoop cycles per second
local oneLoopUpdate = 1 / gameLoopCycles

-- Screen groups
local backGroup
local mainGroup
local uiGroup

-- Screen keys
local optKey
local shopKey
local statsKey
local cheatsKey
local tapKey

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

-- Comments table
local Comment = {
    counter = 0,
    arr = {},
    str1 = {},
    str2 = {},
    str3 = {},
    next = 1
}

-- Speed Measures
local spdMeasure = { 'b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb' }

-------------------------------------------------------------------------------
-- Сonfiguration operations
-------------------------------------------------------------------------------
-- Configuration table
local cfg = {}

-- Link to cfg file
cfgPath = system.pathForFile( "lgccfg.json", system.DocumentsDirectory )

-------------------------------------------------------------------------------
-- Interface windows change
-------------------------------------------------------------------------------

local function gotoOptions()

    composer.gotoScene( "optwindow" )

end

local function gotoShop()

    composer.gotoScene( "windowshop" )

end

local function gotoStats()

    composer.gotoScene( "windowstat" )

end

local function gotoCheats()

    composer.gotoScene( "windowcheat" )

end

-------------------------------------------------------------------------------
-- In-game logic
-------------------------------------------------------------------------------

-- Round number to base
local function roundTo( roundNumber, roundBase )

	return math.floor( roundNumber * 10 ^ roundBase + 0.5 ) * 0.1 ^ roundBase

end

-- Return difference between 2 measures
local function measureDiff( measureStart, measureEnd )

	return 10 ^ ( 3 * ( measureStart - measureEnd ) )

end

local function tapSingle()
    
    cfg.tapsPlayer = cfg.tapsPlayer + 1
    cfg.tapsTotal = cfg.tapsTotal + 1
    cfg.loadTotal = cfg.loadTotal + cfg.believe * measureDiff ( cfg.believeMeasure, cfg.loadTotalMeasure )

end

--randomly takes strings from table and swap them
commentRnd = function( commentTable )

    for i = 1, #commentTable do

        local v = math.random(#commentTable)
        commentTable[i], commentTable[v] = commentTable[v], commentTable[i]

    end

    return commentTable

end

-- if current taps more than check value - update comments
local function checkUpdateComments( currentTaps, checkTaps )
    
    if ( currentTaps > ( checkTaps + 30 ) ) then

        Comment.str1.text = Comment.str2.text
        Comment.str2.text = Comment.str3.text
        Comment.str3.text = Comment.arr[Comment.next]
        Comment.next = Comment.next + 1
        
        if ( Comment.next > #Comment.arr ) then

            Comment.next = 1

        end

        return currentTaps

    else

        return checkTaps

    end

end

-- Every gameLoopDelay launch function
local function gameLoop()

	-- Update Load Total
    cfg.loadTotal = cfg.loadTotal + cfg.loadSpeed * oneLoopUpdate * measureDiff( cfg.loadSpeedMeasure, cfg.loadTotalMeasure )

    -- Every loop check how much taps does player, and if enough - add new comment
    Comment.counter = checkUpdateComments(cfg.tapsTotal, Comment.counter)

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
        cfg = LoadSave.cfgReset( cfg, cfgPath )
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

    -- Reset if set this in options
    if ( composer.getVariable( "gameReset" ) ) then
        composer.setVariable( "gameReset", false )
        cfg = LoadSave.cfgReset( cfg, cfgPath )
    end
	
    --Load Game
    cfg = LoadSave.cfgLoad( cfg, cfgPath )

    Comment.counter = cfg.tapsTotal

    -- Loading comments
    commentLoad = function( commentTable )

        local commentFile = io.open( "cmtanother.json", "r" )

        if commentFile then

            local contents = commentFile:read( "*a" )
            io.close( commentFile )
            commentTable = json.decode( contents )

        end

        return commentTable

    end

    Comment.arr = commentLoad(Comment.arr)
    Comment.arr = commentRnd(Comment.arr)

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

    Comment.str1 = display.newText( backGroup, '', 10, 60, panelFont, 30 )
    Comment.str1:setFillColor( 0, 0, 0 )
    Comment.str1.anchorX = 0
    Comment.str1.anchorY = 0

    Comment.str2 = display.newText( backGroup, '', 10, 90, panelFont, 30 )
    Comment.str2:setFillColor( 0, 0, 0 )
    Comment.str2.anchorX = 0
    Comment.str2.anchorY = 0

    Comment.str3 = display.newText( backGroup, '', 10, 120, panelFont, 30 )
    Comment.str3:setFillColor( 0, 0, 0 )
    Comment.str3.anchorX = 0
    Comment.str3.anchorY = 0

    -- top bar, centered and also all texts ready to refresh
    local topbar = display.newImageRect( backGroup, "assets/001/topbar.png", 1280, 60 )
    topbar.x = display.contentCenterX
    topbar.y = 30

    textLoadTot = display.newText( uiGroup, cfg.loadTotal, 160, panelPosY, panelFont, 36 ) -- Loading Total moved
    textLoadTot:setFillColor( 0, 0, 0 )

    textBelieve = display.newText( uiGroup, cfg.tapsTotal, 480, panelPosY, panelFont, 36 )
    textBelieve:setFillColor( 0, 0, 0 )

    textLoadSpd = display.newText( uiGroup, cfg.loadSpeed, 800, panelPosY, panelFont, 36 )
    textLoadSpd:setFillColor( 0, 0, 0 )

    textLoadData = display.newText( uiGroup, cfg.loadData, 1090, panelPosY, panelFont, 36 )
    textLoadData:setFillColor( 0, 0, 0 )

    local optKey = display.newImageRect( mainGroup, "assets/001/options.png", 60, 60 )
    optKey.x = 1250
    optKey.y = 30    

    local shopKey = display.newImageRect( mainGroup, "assets/001/shop.png", 320, 150 )
    shopKey.x = 160
    shopKey.y = 240

    local statsKey = display.newImageRect( mainGroup, "assets/001/stats.png", 320, 150 )
    statsKey.x = 160
    statsKey.y = 390

    local cheatsKey = display.newImageRect( mainGroup, "assets/001/cheats.png", 320, 150 )
    cheatsKey.x = 160
    cheatsKey.y = 540

    local tapKey = display.newImageRect( mainGroup, "assets/001/tapkey.png", 400, 400 )
    tapKey.x = display.contentCenterX
    tapKey.y = display.contentCenterY
    
    optKey:addEventListener( "tap", gotoOptions )
    shopKey:addEventListener( "tap", gotoShop )
    statsKey:addEventListener( "tap", gotoStats )
    cheatsKey:addEventListener( "tap", gotoCheats )
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
        LoadSave.cfgSave( cfg, cfgPath )
        composer.removeScene( "game" )
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
