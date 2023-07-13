ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Tupe:onkotiirikka')
AddEventHandler('Tupe:onkotiirikka', function (item, amount)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local item     = 'lockpick'
    local xItem = xPlayer.getInventoryItem(item)

	if xItem.count >= 1 then
		TriggerClientEvent('Tupe:Aloitatiirikoiminen', source)
	end
   if xItem.count == 0 then
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Sinulla ei ole Tiirikkaa'})
   end
end)


ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('Tupe:Aloitatiirikoiminen', source)
end)

RegisterServerEvent('Tupe:tiirikkarikki')
AddEventHandler('Tupe:tiirikkarikki', function ()
	local src = source
	local item     = 'lockpick'
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeInventoryItem(item, 1)
end)

RegisterServerEvent('tupe:SoitanPoliisille')
AddEventHandler('tupe:SoitanPoliisille', function(pos)
	TriggerClientEvent('tupe:SoitanPoliisille', -1, pos)
end)

function KuinkamontaPoliisia()
	local xPlayers = ESX.GetPlayers()
	poliisit = 0
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			poliisit = poliisit + 1
		end
	end
	SetTimeout(1*1000*60, KuinkamontaPoliisia)
end
