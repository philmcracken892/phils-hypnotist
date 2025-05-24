local RSGCore = exports['rsg-core']:GetCoreObject()

RSGCore.Functions.CreateUseableItem('hipwatch', function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    TriggerClientEvent('rsg-hipwatch:client:openHipwatchMenu', source)
end)

RegisterNetEvent('rsg-hipwatch:server:ragdollClosestPlayer', function(userCoords)
    local src = source 
    local users = RSGCore.Functions.GetPlayers()
    local closestPlayer = nil
    local closestDistance = math.huge
    local maxDistance = 20.0 
    
    for _, playerId in pairs(users) do
        if playerId ~= src then 
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(userCoords - targetCoords)
            
            if distance <= maxDistance and distance < closestDistance then
                closestDistance = distance
                closestPlayer = playerId
            end
        end
    end
    
    if closestPlayer then
        TriggerClientEvent('rsg-hipwatch:client:ragdollPlayer', closestPlayer)
        TriggerClientEvent('rsg-hipwatch:client:notify', src, {
            title = 'Hipwatch',
            description = 'Successfully hypnotized nearby player!',
            type = 'success'
        })
    else
        TriggerClientEvent('rsg-hipwatch:client:notify', src, {
            title = 'Hipwatch',
            description = 'No players nearby to hypnotize.',
            type = 'error'
        })
    end
end)
        TriggerClientEvent('RSGCore:Notify', src, 'No players nearby to hypnotize.', 'error')
    end
end)
