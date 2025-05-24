local RSGCore = exports['rsg-core']:GetCoreObject()
local isPlaying = false

-- Function to show the hipwatch menu
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

-- Handle ox_lib notifications
RegisterNetEvent('rsg-hipwatch:client:notify', function(data)
    lib.notify({
        title = data.title,
        description = data.description,
        type = data.type
    })
end)

-- Handle hipwatch animation with looping
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

    -- Thread to handle animation looping
    CreateThread(function()
        while isPlaying do
            ClearPedTasks(ped)
            TaskEmote(ped, 0, 2, joaat(emoteType), true, true, true, true, true)
            Wait(10000) -- Duration of one animation cycle
            if isPlaying then
                TriggerServerEvent('rsg-hipwatch:server:ragdollClosestPlayer', GetEntityCoords(ped))
            end
        end
        ClearPedTasksImmediately(ped)
        ClearPedSecondaryTask(ped)
        TaskClearLookAt(ped)
    end)

    -- Thread to handle E key press to stop
    CreateThread(function()
        while isPlaying do
            if IsControlJustPressed(0, 0xCEFD9220) then -- E key
                isPlaying = false
                break
            end
            Wait(0)
        end
    end)

    -- Thread to handle 30-second timeout
    CreateThread(function()
        Wait(30000)
        if isPlaying then
            isPlaying = false
        end
    end)
end)

-- Handle sleep animation for affected players
RegisterNetEvent('rsg-hipwatch:client:ragdollPlayer', function()
    local ped = PlayerPedId()
    ClearPedTasksImmediately(ped) -- Clear existing tasks
    TaskStartScenarioInPlace(ped, joaat('world_human_sleep_ground_arm'), 20000, true, false, false, false) -- Play sleep animation for 5 seconds
    lib.notify({
        title = 'Hypnotized!',
        description = 'You were hypnotized by a hipwatch and fell asleep!',
        type = 'inform'
    })
end)

-- Clean up when resource stops
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
