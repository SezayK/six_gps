local ESX = nil
local blips = {}
local inUse = false

local function haveItem(item, count)
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        if v.name == item then
            if v.count >= count then
                return true
            end
        end
    end

    return false
end

RegisterNetEvent('sixv_gps:sendGPS')
AddEventHandler('sixv_gps:sendGPS', function(peds)
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end

    blips = {}

    if ESX ~= nil then
        for k, v in pairs(peds) do
            if ESX.PlayerData.job.name == v.job and v.playerId ~= GetPlayerServerId(PlayerId()) and haveItem(SIXServ.GPSItem, 1) and inUse and v.inuse == true then
                local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z) 
                SetBlipSprite(blip, 1)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, 0.8)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentSubstringPlayerName(v.rpName)
                EndTextCommandSetBlipName(blip)
                table.insert(blips, blip)
            end
        end 
    end
end)

RegisterNetEvent('sixv_gps:setInUse')
AddEventHandler('sixv_gps:setInUse', function(bool)
    inUse = bool
    gpstrue()
end)

RegisterNetEvent('sixv_gps:clearBlips')
AddEventHandler('sixv_gps:clearBlips', function()
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end

    blips = {}
end)


Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)