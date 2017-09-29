-- Configuration operations functions

-- JSON support
local json = require( "json" )

-- Main collectiton
local LoadSave = {}

-- Saving confguration
LoadSave.cfgSave = function( cfgTable, cfgSavePath )

    local cfgFile = io.open( cfgSavePath, "w" )
 
    if cfgFile then

    	cfgTable.lastTimeSave = os.time()
        cfgFile:write( json.encode( cfgTable ) )
        io.close( cfgFile )

    else

        print( 'cfgSave unsuccess' )

    end

end

-- load defaut data and save confguration
LoadSave.cfgReset = function( defTable, defSavePath )

	local defPath = system.pathForFile( "start.json", system.ResourceDirectory )

    local defFile = io.open( defPath, "r" )

    if defFile then

        local contents = defFile:read( "*a" )
        io.close( defFile )
        defTable = json.decode( contents )
        defTable.lastTimeSave = os.time() -- Date of last save - use to make viruses
        LoadSave.cfgSave( defTable, defSavePath )

    else
        
        print( 'cfgReset unsuccess' )

    end

    return defTable

end

-- Load confguration, if can't - reset
LoadSave.cfgLoad = function( cfgTable, cfgSavePath )

	local cfgFile = io.open( cfgSavePath, "r" )

    if cfgFile then

        local contents = cfgFile:read( "*a" )
        io.close( cfgFile )
        cfgTable = json.decode( contents )

    else
        
    	cfgTable = LoadSave.cfgReset( cfgTable, cfgSavePath )

    end

    return cfgTable

end

return LoadSave