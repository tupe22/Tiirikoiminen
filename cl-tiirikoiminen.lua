ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if DoesEntityExist(GetVehiclePedIsTryingToEnter(PlayerPedId(ped))) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId(ped))
            local lock = GetVehicleDoorLockStatus(veh)
            if lock == 7 then
                SetVehicleDoorsLocked(veh, 2)
            end
            local pedd = GetPedInVehicleSeat(veh, -1)
            if pedd then
                SetPedCanBeDraggedOut(pedd, false)
            end
        end
    end
 end)



 local function SoitanPoliisille()
    local poliisit = math.random(1,100)
    if poliisit <= 100 then --Kuinka suuri todennäköisyys siihen että Poliisille tulee ilmoitus
        TriggerServerEvent('tupe:SoitanPoliisille', GetEntityCoords(PlayerPedId()))
        FreezeEntityPosition(PlayerPedId(), false)
    end    
 end

 local locked = false

 local function lockpickVehicle()
     ped = PlayerPedId()
     pedc = GetEntityCoords(ped)
     local veh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 3.0, 0, 71)
 
     exports['mythic_notify']:DoLongHudText('inform', 'Aloitit Tiirikoimisen')
 
     local success = lib.skillCheck({'easy', 'easy', {areaSize = 50, speedMultiplier = 1}, 'easy'}, {'w', 'a', 's', 'd'})
 
     if success then
         Wait(1000)
         ExecuteCommand("e uncuff")
         Wait(500)
         ClearPedTasks(PlayerPedId())
         FreezeEntityPosition(PlayerPedId(), false)
         exports['mythic_notify']:DoLongHudText('success', 'Onnistuit Tiirikoinnissa')
         SetVehicleDoorsLocked(veh, 0)
         SetVehicleDoorsLockedForAllPlayers(veh, false)
     else
         SoitanPoliisille()
         Wait(500)
         ClearPedTasks(PlayerPedId())
         Wait(500)
         exports['mythic_notify']:DoLongHudText('error', 'Epäonnistuit tiirikoinnissa ja ajoneuvon hälytys laukesi')
         TriggerServerEvent('Tupe:tiirikkarikki')
         FreezeEntityPosition(PlayerPedId(), false)
         SetVehicleAlarm(veh, true)
         SetVehicleAlarmTimeLeft(veh, 4000)
         SetVehicleDoorsLocked(veh, 2)
     end
 end
 
 RegisterNetEvent('Tupe:Aloitatiirikoiminen')
 AddEventHandler('Tupe:Aloitatiirikoiminen', function()
     local ped = PlayerPedId()
     local pedc = GetEntityCoords(ped)
     local closeveh = GetClosestVehicle(pedc.x, pedc.y, pedc.z, 5.0, 0 ,71)
     local lockstatus = GetVehicleDoorLockStatus(closeveh)
     local distance = #(GetEntityCoords(closeveh) - pedc)
     if distance < 3 then
         if lockstatus == 2 then
           --  lockpickVehicle()
             ExecuteCommand('e uncuff')
             SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"),true)
             FreezeEntityPosition(PlayerPedId(), true)
             lockpickVehicle()
         else
             exports['mythic_notify']:DoLongHudText('inform', 'Ajoneuvo ei ole lukossa')
             FreezeEntityPosition(PlayerPedId(), false)
         end
     else
         exports['mythic_notify']:DoLongHudText('error', 'Ei ajoneuvoja lähellä')
         FreezeEntityPosition(PlayerPedId(), false)
     end
 end)
 
 exports.ox_target:addGlobalVehicle({
     {
         name = 'Tupe:Tiirikointi',
         icon = 'fa-solid fa-car-side',
         label = 'Tiirikoi',
         bones = {'door_dside_f'},
         items = 'lockpick',
         --anyItem = 'true',
         canInteract = function(entity, distance, coords, name)
             if GetVehicleDoorLockStatus(entity) > 7 then return end
 
             local boneId = GetEntityBoneIndexByName(entity, 'door_dside_f')
 
             if IsVehicleDoorDamaged(entity, 0) then return end
 
             if boneId ~= -1 then
                 return #(coords - GetEntityBonePosition_2(entity, boneId)) < 0.5 or #(coords - GetEntityBonePosition_2(entity, GetEntityBoneIndexByName(entity, 'seat_dside_f'))) < 0.72
             end
         end,
         onSelect = function(data)
             TriggerServerEvent('Tupe:onkotiirikka')
         end
     }
 })
 
RegisterNetEvent('tupe:SoitanPoliisille')
AddEventHandler('tupe:SoitanPoliisille', function(pos)
	if ESX.PlayerData.job.name ~= nil then
		if ESX.PlayerData.job.name == "police" then
			CreateThread(function()
				ESX.ShowAdvancedNotification('Hätäkeskus','Silminnäkijä ilmoittaa', 'Henkilö on nähty Tiirikoimassa ajoneuvoa', 'CHAR_CHAT_CALL', 2, false, false, 27)
				local ilmoitus = AddBlipForCoord(pos)
				SetBlipSprite(ilmoitus , 161)
				SetBlipScale(ilmoitus , 1.0)
				SetBlipColour(ilmoitus, 29)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Silminnäkijän ilmoitus')
				EndTextCommandSetBlipName(ilmoitus)
				PulseBlip(ilmoitus)
				Wait(10*1000)
				RemoveBlip(ilmoitus)
			end)
		end
	end
end)
