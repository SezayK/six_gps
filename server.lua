ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local inuse = {}
local Dead = {}


AddEventHandler('onResourceStart', function()
    startgps()
end)

ESX.RegisterUsableItem(SIXServ.GPSItem, function(source)
    if inuse[source] == true or inuse[source] == nil then
        inuse[source] = true
        TriggerClientEvent("sixv_gps:setInUse", source, true)
    else
        inuse[source] = false
        TriggerClientEvent("sixv_gps:setInUse", source, false)
        TriggerClientEvent("sixv_gps:clearBlips", source)
    end
end)

function startgps()
    SetTimeout(SIXServ.refreshtime, function()
        local xPlayers = ESX.GetPlayers()
        local players = {}

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            for _,job in pairs(SIXServ.NoAccessToGPS) do
                if PlayerData.job.name ~= job then
                    if inuse[xPlayer.source] ~= false then
                        table.insert(players, {
                            playerId = xPlayer.source,
                            identifier = xPlayer.identifier,
                            rpName = xPlayer.name,
                            job = xPlayer.job.name,
                            coords = xPlayer.coords,
                            inuse = inuse[xPlayer.source],
                        })
                    end
                end
            end
        end
        TriggerClientEvent("sixv_gps:sendGPS", -1, players)
        startgps()
    end)
end