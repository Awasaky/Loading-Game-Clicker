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
LoadSave.cfgReset = function( cfgTable, cfgSavePath )

	local cfgFile = io.open( "start.json", "r" )

    if cfgFile then

        local contents = cfgFile:read( "*a" )
        io.close( cfgFile )
        cfgTable = json.decode( contents )
        cfgTable.lastTimeSave = os.time() -- Date of last save - use to make viruses
        LoadSave.cfgSave( cfgTable, cfgSavePath )

    end

    return cfgTable

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

    	LoadSave.cfgReset( cfgSavePath )

    end

    return cfgTable

end

return LoadSave