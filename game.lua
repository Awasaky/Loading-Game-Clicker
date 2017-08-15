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

-- Asset loading
-- Asset configuration definition
local pathAsset = system.pathForFile( "lgcconfig.json", system.DocumentsDirectory )

-- объект конфигурации
local tableAsset = {}

-- сохранение конфигурации
local function saveAsset()
 
    local fileConfig = io.open( pathConfig, "w" )
 
    if fileConfig then
        fileConfig:write( json.encode( tableConfig ) )
        io.close( fileConfig )
    end
end

-- сброс конфигурации и её сохранение в файл
local function resetAsset()
    tableConfig = {
       	tapsPlayer = 0,
       	tapsTotal = 0,
       	loadTotal = 0,
       	lastTimeSave = os.time()
   	}
 	saveConfig()  	
end

local function loadAsset()
 
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
	loadConfig()
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
