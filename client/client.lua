local isTransformed      = false
local currentItem        = nil

local originalAppearance = nil
local originalModel      = nil
local transformTimer     = nil
local useIllenium        = GetResourceState('illenium-appearance') == 'started'
local useQBClothing      = GetResourceState('qb-clothing') == 'started'
local hudRemaining       = 0

local function SaveState()
    originalModel = GetEntityModel(PlayerPedId())
    if useIllenium then
        exports['illenium-appearance']:RequestPlayerAppearance(function(a) originalAppearance = { type = 'illenium', data = a } end)
    elseif useQBClothing then
        exports['qb-clothing']:GetPlayerSkin(function(s) originalAppearance = { type = 'qbclothing', data = s } end)
    end
end

local function RestoreState()
    if originalModel then
        RequestModel(originalModel)
        while not HasModelLoaded(originalModel) do Wait(50) end
        SetPlayerModel(PlayerPedId(), originalModel)
        SetModelAsNoLongerNeeded(originalModel)
        SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
    end
    if originalAppearance then
        if originalAppearance.type == 'illenium' then
            exports['illenium-appearance']:SetPlayerAppearance(originalAppearance.data)
        else
            exports['qb-clothing']:SetPlayerSkin(originalAppearance.data)
        end
    end
    originalModel = nil
    originalAppearance = nil
end

local function DrawHUD()
    if Config.HUD.enabled and hudRemaining > 0 then
        SetTextFont(Config.HUD.font)
        SetTextScale(Config.HUD.scale, Config.HUD.scale)
        SetTextColour(Config.HUD.color.r, Config.HUD.color.g, Config.HUD.color.b, Config.HUD.color.a)
        SetTextCentre(true)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(('Time: %s'):format(hudRemaining))
        EndTextCommandDisplayText(Config.HUD.x, Config.HUD.y)
    end
end

CreateThread(function()
    while true do
        DrawHUD()
        Wait(500)
    end
end)

local function PlayDrinkEffect(sound, cb)
    local ped = PlayerPedId()
    local anim = Config.DrinkAnim
    RequestAnimDict(anim.dict)
    while not HasAnimDictLoaded(anim.dict) do Wait(10) end
    TaskPlayAnim(ped, anim.dict, anim.name, 8.0, -8, -1, 48, 0, false, false, false)
    if exports['progressbar'] then
        exports['progressbar']:startUI({ duration = Config.Progress.duration, label = Config.Progress.label })
    else
        Citizen.Wait(Config.Progress.duration)
    end
    UseParticleFxAssetNextCall(Config.Particle.asset)
    local coords = GetEntityCoords(ped)
    StartParticleFxNonLoopedAtCoord(Config.Particle.name, coords.x, coords.y, coords.z + 1.0, 0, 0, 0, 1.0, false, false, false)
    StopAnimTask(ped, anim.dict, anim.name, 1.0)
    if sound then PlaySoundFrontend(-1, sound.name, sound.dict, true) end
    cb()
end

RegisterNetEvent('transform:client:Transform', function(itemName)
    if isTransformed then
        TriggerEvent('chat:addMessage', { args = { 'Error', 'Revert first.' } })
        return
    end
    local info = Config.Transformations[itemName]
    PlayDrinkEffect(info.sound, function()
        SaveState()
        local hash = GetHashKey(info.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do Wait(50) end
        SetPlayerModel(PlayerPedId(), hash)
        SetModelAsNoLongerNeeded(hash)
        if info.speedMultiplier then
            SetRunSprintMultiplierForPlayer(PlayerPedId(), info.speedMultiplier)
        end
        isTransformed = true
        currentItem = itemName
        hudRemaining = info.duration
        TriggerEvent('chat:addMessage', { args = { 'Success', ('Transformed into %s!'):format(info.label) } })
        TriggerServerEvent('transform:server:Log', GetPlayerServerId(PlayerId()), 'transform', itemName)
        if transformTimer then CancelEvent(transformTimer) end
        transformTimer = SetTimeout(1000, function()
            hudRemaining = math.max(hudRemaining - 1, 0)
            if hudRemaining > 0 then
                transformTimer = SetTimeout(1000, transformTimer)
            else
                TriggerEvent('transform:client:Revert')
            end
        end)
    end)
end)

RegisterNetEvent('transform:client:Revert', function()
    if not isTransformed then
        TriggerEvent('chat:addMessage', { args = { 'Info', 'Already human.' } })
        return
    end
    PlayDrinkEffect(nil, function()
        RestoreState()
        isTransformed = false
        hudRemaining = 0
        TriggerEvent('chat:addMessage', { args = { 'Success', 'Reverted to original form!' } })
        TriggerServerEvent('transform:server:Log', GetPlayerServerId(PlayerId()), 'revert', currentItem)
        currentItem = nil
    end)
end)
