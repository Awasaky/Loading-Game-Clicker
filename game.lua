-- -----------------------------------------------------------------------------------
-- Есть условно первоначальный старт, в котором в зависимости от числа кликов, отображаются разные элементы
-- и обычный запуск игры, в котором уже элементы интерфейса все видны и надо подключать ботов и вирусы
-- -----------------------------------------------------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- variables to build scene
local gameLoopTimer

local backGroup -- background group
local mainGroup -- primary group
local uiGroup -- information group

local panelFont = native.newFont( "Arial Black" )
local panelPosY = 40

local textTapsSpd
local textBelieve
local textLoadSpd
local textLoadTot

local tapsPlayerPrev = 0

local json = require( "json" )

-- Сonfiguration files operations
-- Link to config file
local pathConfig = system.pathForFile( "lgcconfig.json", system.DocumentsDirectory )

-- Configuration table
local tableConfig = {}

-- Saving configuration
local function saveConfig()
 
    local fileConfig = io.open( pathConfig, "w" )
 
    if fileConfig then
        fileConfig:write( json.encode( tableConfig ) )
        io.close( fileConfig )
    end
end

-- Reset and save configuration
local function resetConfig()
    tableConfig = {
       	tapsPlayer = 0,
       	tapsTotal = 0,
       	loadTotal = 0,
       	lastTimeSave = os.time()
   	}
 	saveConfig()  	
end

-- Load Configuration
local function loadConfig()
 
    local fileConfig = io.open( pathConfig, "r" )

    if fileConfig then
        local contents = fileConfig:read( "*a" )
        io.close( fileConfig )
        tableConfig = json.decode( contents )
    end
 
    if ( tableConfig == nil or #tableConfig == 0 ) then
    	resetConfig()
    end
end

local function gotoShop()

end

local function gotoStats()

end

local function gotoCheats()

end

local function tapSingle()

    tableConfig.tapsPlayer = tableConfig.tapsPlayer + 1

end

local function gameLoop()

    local lastTaps
    lastTaps = ( tableConfig.tapsPlayer - tapsPlayerPrev ) * 10
    textTapsSpd.text = lastTaps
    tapsPlayerPrev = tableConfig.tapsPlayer
    textLoadTot.text = tableConfig.tapsPlayer

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	loadConfig() -- загрузка конфигурации

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

    textTapsSpd = display.newText( uiGroup, tableConfig.tapsTotal, 160, panelPosY, panelFont, 36 )
    textTapsSpd:setFillColor( 0, 0, 0 )

    textBelieve = display.newText( uiGroup, tableConfig.tapsTotal, 480, panelPosY, panelFont, 36 )
    textBelieve:setFillColor( 0, 0, 0 )

    textLoadSpd = display.newText( uiGroup, tableConfig.tapsTotal, 800, panelPosY, panelFont, 36 )
    textLoadSpd:setFillColor( 0, 0, 0 )

    textLoadTot = display.newText( uiGroup, tableConfig.tapsTotal, 1120, panelPosY, panelFont, 36 )
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
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 100, gameLoop, 0 )
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
		-- composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	saveConfig()
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
