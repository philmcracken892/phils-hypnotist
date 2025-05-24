local RSGCore = exports['rsg-core']:GetCoreObject()
local isPlaying = false


local function ShowHipwatchMenu()
    ExecuteCommand('closeInv')
    lib.registerContext({
        id = 'hipwatch_selection_menu',
        title = 'Use Hipwatch',
        options = {
            {
                title = 'Use Hipwatch',
                description = 'Use the hipwatch to hypnotize nearby players.',
                icon = 'fas fa-clock',
                onSelect = function()
                    TriggerEvent('rsg-hipwatch:client:playHipwatch')
                end
            }
        }
    })
    lib.showContext('hipwatch_selection_menu')
end


RegisterNetEvent('rsg-hipwatch:client:notify', function(data)
    lib.notify({
        title = data.title,
        description = data.description,
        type = data.type
    })
end)


RegisterNetEvent('rsg-hipwatch:client:playHipwatch', function()
    if isPlaying then return end
    isPlaying = true
    local ped = PlayerPedId()
    local emoteType = 'KIT_EMOTE_ACTION_HYPNOSIS_POCKET_WATCH_1'

    lib.notify({
        title = 'Using Hipwatch',
        description = 'Press [E] to stop using',
        type = 'info'
    })

    
    CreateThread(function()
        while isPlaying do
            ClearPedTasks(ped)
            TaskEmote(ped, 0, 2, joaat(emoteType), true, true, true, true, true)
            Wait(5000) 
            if isPlaying then
                TriggerServerEvent('rsg-hipwatch:server:ragdollClosestPlayer', GetEntityCoords(ped))
            end
        end
        ClearPedTasksImmediately(ped)
        ClearPedSecondaryTask(ped)
        TaskClearLookAt(ped)
    end)

    
    CreateThread(function()
        while isPlaying do
            if IsControlJustPressed(0, 0xCEFD9220) then -- E key
                isPlaying = false
                break
            end
            Wait(0)
        end
    end)

   
    CreateThread(function()
        Wait(60000)
        if isPlaying then
            isPlaying = false
        end
    end)
end)


RegisterNetEvent('rsg-hipwatch:client:ragdollPlayer', function()
    local ped = PlayerPedId()
    SetPedToRagdoll(ped, 2000, 2000, 0, true, true, false)
    lib.notify({
        title = 'Hypnotized!',
        description = 'You were affected by a hipwatch and fell to the ground!',
        type = 'inform'
    })
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if isPlaying then
        local ped = PlayerPedId()
        ClearPedTasksImmediately(ped)
        ClearPedSecondaryTask(ped)
        TaskClearLookAt(ped)
        isPlaying = false
    end
end)

-- Open hipwatch menu
RegisterNetEvent('rsg-hipwatch:client:openHipwatchMenu', function()
    ShowHipwatchMenu()
end)
