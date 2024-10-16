lib.callback.register('star-blackmarket:server:cb:return:items', function(source)
    local items = {}
    local xPlayer = ESX.GetPlayerFromId(source)

    for _, item in pairs(Shared.Items) do
        if xPlayer.getMoney() < item.price then
            table.insert(items, {
                title = ('%s - €%s'):format(item.label, item.price),
                description = ('Je mist €%s contant voor deze item'):format(item.price - xPlayer.getMoney()),
                disabled = true,
                icon = 'person-circle-exclamation'
            })
        else
            table.insert(items, {
                title = ('%s - €%s'):format(item.label, item.price),
                description = ('Koop %s voor €%s'):format(item.label, item.price),
                serverEvent = 'star-blackmarket:server:buy:item',
                icon = 'money-bill',
                args = {
                    item = item.spawnCode,
                }
            })
        end
    end

    return items
end)

lib.callback.register('star-blackmarket:server:cb:return:shared', function()
    return Shared
end)

lib.callback.register('star-blackmarket:server:cb:spawn:ped', function()
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    local ped = CreatePed(4, Shared.Ped['model'], Shared.Ped['coords'], Shared.Ped['heading'], false, true)
    return NetworkGetNetworkIdFromEntity(ped)
end)

RegisterServerEvent('star-blackmarket:server:buy:item', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() < Shared.Items[data.item].price then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Blackmarket',
            description = ('Je mist %s contant voor deze item'):format(Shared.Items[data.item].price - xPlayer.getMoney()),
            type = 'error'
        })
        return
    end

    exports.ox_inventory:RemoveItem(source, 'cash', Shared.Items[data.item].price)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Blackmarket',
        description = ('Je hebt %s gekocht voor %s'):format(Shared.Items[data.item].label, Shared.Items[data.item].price),
        type = 'success'
    })
    
    exports.ox_inventory:AddItem(source, data.item, 1)
end)