local json = require( "json" )

local LoadSave = {}

-- Saving cfguration
LoadSave.cfgSave = function( cfgTable, cfgSavePath )

    local cfgFile = io.open( cfgSavePath, "w" )
 
    if cfgFile then

    	cfgTable.lastTimeSave = os.time()
        cfgFile:write( json.encode( cfgTable ) )
        io.close( cfgFile )

    end

end

-- load defaut data and save cfguration
LoadSave.cfgReset = function( defTable, defSavePath )

	local defPath = system.pathForFile( "start.json", system.ResourceDirectory )

    local defFile = io.open( defPath, "r" )

    if defFile then

        local contents = defFile:read( "*a" )
        io.close( defFile )
        defTable = json.decode( contents )
        defTable.lastTimeSave = os.time() -- Date of last save - use to make viruses
        LoadSave.cfgSave( defTable, defSavePath )

    end

    return defTable

end

-- Load Configuration, if can't - reset
LoadSave.cfgLoad = function( cfgTable, cfgSavePath )

	local cfgFile = io.open( cfgSavePath, "r" )

    if cfgFile then

        local contents = cfgFile:read( "*a" )
        io.close( cfgFile )
        cfgTable = json.decode( contents )

    end
    
    if ( cfgTable == nil or cfgTable.loadTotal == nil ) then

    	cfgTable = LoadSave.cfgReset( cfgTable, cfgSavePath )

    end

    return cfgTable

end

return LoadSave