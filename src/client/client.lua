-- // { VARIABLES } \\ --
Shared = lib.callback.await('star-blackmarket:server:cb:return:shared', false)
local currentPed

-- // { THREADS } \\ --
CreateThread(function()
    -- // { SPAWN PED } \\ --
    lib.requestModel(Shared.Ped['model'])

    if Shared then print('^3[STAR-BLACKMARKET]^7 ^2Shared^7 has succesfully loaded!') end
    
    currentPed = CreatePed(4, Shared.Ped['model'], Shared.Ped['coords'], Shared.Ped['heading'], false, true)
    SetEntityInvincible(currentPed, true)
    FreezeEntityPosition(currentPed, true)
    SetBlockingOfNonTemporaryEvents(currentPed, true)
    SetEntityAsMissionEntity(currentPed, true, true)
    SetPedDiesWhenInjured(currentPed, false)
    SetPedCanRagdollFromPlayerImpact(currentPed, false)

    -- // { BLIP } \\ --
    if Shared.Blip['blipEnabled'] then
        local blip = AddBlipForCoord(Shared.Ped['coords'])
        SetBlipSprite(blip, Shared.Blip['blipSprite'])
        SetBlipDisplay(blip, Shared.Blip['blipDisplay'])
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Shared.Blip['blipName'])
        EndTextCommandSetBlipName(blip)
    end

    -- // { OX_TARGET } \\ --
    
    exports.ox_target:addLocalEntity(currentPed, {
        {
            name = 'blackmarket',
            icon = 'fas fa-store',
            label = 'Open de blackmarket',
            onSelect = function()
                local opts = lib.callback.await('star-blackmarket:server:cb:return:items', false)
                lib.registerContext({
                    id = 'target_blackmarket',
                    title = 'Blackmarket',
                    options = opts
                })
                lib.showContext('target_blackmarket')
            end
        }
    })

    print('^3[STAR-BLACKMARKET]^7 ^2Blackmarket^7 has succesfully started!')
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if DoesEntityExist(currentPed) then
        DeletePed(currentPed)
    end
end)