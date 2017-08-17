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
local panelPosY = 70

local textTapsTot
local textTapsSpd
local textBelieve
local textLoadSpd
local textLoadTot

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
    -- 720 / 4 == 180
    local background = display.newImageRect( backGroup, "assets/001/back.png", 1280, 720 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local topbar = display.newImageRect( backGroup, "assets/001/topbar.png", 1600, 90 )
    topbar.x = display.contentCenterX + 160
    topbar.y = 45

    textTapsSpd = display.newText( uiGroup, tableConfig.tapsTotal, 160, panelPosY, panelFont, 36 )
    textTapsSpd:setFillColor( 0, 0, 0 )

    textBelieve = display.newText( uiGroup, tableConfig.tapsTotal, 480, panelPosY, panelFont, 36 )
    textBelieve:setFillColor( 0, 0, 0 )

    textLoadSpd = display.newText( uiGroup, tableConfig.tapsTotal, 820, panelPosY, panelFont, 36 )
    textLoadSpd:setFillColor( 0, 0, 0 )

    textLoadTot = display.newText( uiGroup, tableConfig.tapsTotal, 1150, panelPosY, panelFont, 36 )
    textLoadTot:setFillColor( 0, 0, 0 )

    local shopKey = display.newImageRect( mainGroup, "assets/001/shop.png", 120, 60 )
    shopKey.x = 60
    shopKey.y = 130

    local statsKey = display.newImageRect( mainGroup, "assets/001/stats.png", 120, 60 )
    statsKey.x = 60
    statsKey.y = 190

    local cheatsKey = display.newImageRect( mainGroup, "assets/001/cheats.png", 120, 60 )
    cheatsKey.x = 60
    cheatsKey.y = 250

    local tapKey = display.newImageRect( mainGroup, "assets/001/tapkey.png", 360, 360 )
    tapKey.x = display.contentCenterX
    tapKey.y = display.contentCenterY
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
