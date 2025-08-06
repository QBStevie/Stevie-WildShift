local oxActive    = GetResourceState('ox_inventory') == 'started'
local qbInvActive = GetResourceState('qb-inventory') == 'started'
local playerCooldowns = {}

local function canUse(src)
    local now = os.time()
    if not playerCooldowns[src] or now - playerCooldowns[src] >= Config.Cooldown then
        playerCooldowns[src] = now
        return true
    end
    return false
end

if oxActive or qbInvActive then
    local QBCore = qbInvActive and exports['qb-core']:GetCoreObject() or nil
    for itemName, info in pairs(Config.Transformations) do
        if oxActive then
            exports.ox_inventory:RegisterUsableItem(itemName, function(player)
                if not canUse(player) then
                    TriggerClientEvent('chat:addMessage', player, { args = {'Error','Cooldown active.'} })
                    return
                end
                exports.ox_inventory:RemoveItem(itemName, 1)
                exports.ox_inventory:AddItem(Config.RevertItem, 1)
                TriggerClientEvent('transform:client:Transform', player, itemName)
            end)
        else
            QBCore.Functions.CreateUseableItem(itemName, function(source)
                if not canUse(source) then
                    TriggerClientEvent('chat:addMessage', source, { args = {'Error','Cooldown active.'} })
                    return
                end
                QBCore.Functions.RemoveItem(itemName,1)
                QBCore.Functions.AddItem(Config.RevertItem,1)
                TriggerClientEvent('transform:client:Transform', source, itemName)
            end)
        end
    end
    if oxActive then
        exports.ox_inventory:RegisterUsableItem(Config.RevertItem, function(player)
            exports.ox_inventory:RemoveItem(Config.RevertItem,1)
            TriggerClientEvent('transform:client:Revert', player)
        end)
    else
        QBCore.Functions.CreateUseableItem(Config.RevertItem, function(source)
            QBCore.Functions.RemoveItem(Config.RevertItem,1)
            TriggerClientEvent('transform:client:Revert', source)
        end)
    end
end

RegisterNetEvent('transform:server:Log', function(src, action, item)
    print(('[transform] Player %s performed %s with %s'):format(src, action, item))
end)
