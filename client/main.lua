ESX              = nil
local PlayerData = {}
local isMenuOn = false
local marker1spawnt = false
local display = false
local event_destination = nil
local isMining = false
local newSpawnReady = true
local prop_active = false

--shop--
local shopCostMenu = 0
local pickaxeCounter = 0

--ores--
local goldOresCount = 0
local DiamondOresCount = 0
local EmeraldOresCount = 0
local ironOresCount = 0
local impacts = 0


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	Citizen.Wait(100)
	while true do
		TriggerServerEvent("refreshItems:minerJob")
		Citizen.Wait(10000)
	end
end)





--HTML function--
Citizen.CreateThread(function()
	function SetDisplay(bool)
		display = bool
		SetNuiFocus(bool, bool)
		SendNUIMessage({
			type = "ui",
			status = bool,
			DiamondOres = DiamondOresCount,
			EmeraldOres = EmeraldOresCount,
			goldOres = goldOresCount,
			ironOres = ironOresCount,
		})
	end
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		local x,y,z  = -601.15631103516,2092.1804199219,130.34860229492
		Citizen.Wait(0)
		for i, v in ipairs(Config.Marker) do
			local distance2 = GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true)
			DrawMarker(2, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 255, 110, 0, 1, 0, 1)
			if distance2 <= 7 and distance2 >= 1.5 and distance2 ~= -1 then
				DrawText3Ds(x,y,z+2, _U('T_MP'), 0)
			end
			if distance2 <= 1 and distance2 ~= -1 then
				if isMenuOn == false and prop_active == false  then
					create_object()
					prop_active = true
					SetDisplay(not display)
					isMenuOn = true
					if Config.enabledebug then
						exports['okokNotify']:Alert("Minero", "Props spawneado "..tostring(prop_active).."", 5000, 'success')
					end
				elseif isMenuOn == false and prop_active then
					SetDisplay(not display)
					isMenuOn = true
					if Config.enabledebug then
						exports['okokNotify']:Alert("Minero", "menu abierto y prop detectados", 5000, 'success')
					end
				end
					
			end
			if prop_active and distance2 >= 150 and distance2 ~= -1 then
				prop_active = false
				if Config.enabledebug then
					exports['okokNotify']:Alert("Minero", "el estado es "..tostring(prop_active).."", 5000, 'success')
				end
			end
		end

				
		
	end
	while display do
		Citizen.Wait(10)
		DisableControlAction(0, 1, display) -- LookLeftRight
		DisableControlAction(0, 2, display) -- LookUpDown
		DisableControlAction(0, 142, display) -- MeleeAttackAlternate
		DisableControlAction(0, 18, display) -- Enter
		DisableControlAction(0, 322, display) -- ESC
		DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
	end
end)
--main function--
Citizen.CreateThread(function()
	for _, info in pairs(Config.Blip) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, 0.9)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
	end
	function mining()
		isMining = true
		Citizen.CreateThread(function()
			while impacts < 3 do
				Citizen.Wait(1)
				local ped = PlayerPedId()	
				RequestAnimDict("amb@world_human_hammering@male@base")
				Citizen.Wait(100)
				TaskPlayAnim((ped), 'amb@world_human_hammering@male@base', 'base', 12.0, 12.0, -1, 80, 0, 0, 0, 0)
				SetEntityHeading(ped, 270.0)
				if impacts == 0 then
					pickaxe = CreateObject(GetHashKey("prop_tool_pickaxe"), 0, 0, 0, true, true, true) 
					AttachEntityToEntity(pickaxe, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.18, -0.02, -0.02, 350.0, 100.00, 140.0, true, true, false, true, 1, true)
				end 
				exports.rprogress:Start("", 2500)
				impacts = impacts+1
				if impacts == 3 then
					DetachEntity(pickaxe, 1, true)
					DeleteEntity(pickaxe)
					DeleteObject(pickaxe)
					impacts = 0
					Citizen.Wait(1000)
					TriggerServerEvent("addItems:minerJob")
					isMining = false
						
					break
				end        
			end
		end)
	end
	function spawnNewMarker1()
		marker1spawnt = false
		random_destination = math.random(1, #Config.mining.MiningPoints)
		random_destination2 = math.random(1, #Config.mining.MiningPoints2)
		random_destination3 = math.random(1, #Config.mining.MiningPoints3)
		Citizen.Wait(1000)
		marker1spawnt = true	
	end
	Citizen.Wait(4)
	RequestModel(Config.NPCHash)
	while not HasModelLoaded(Config.NPCHash) do
		Citizen.Wait(4)
	end
		MinerNPC = CreatePed(1, Config.NPCHash, -601.15631103516,2092.1804199219,130.34860229492, 60, false, true)
		SetBlockingOfNonTemporaryEvents(MinerNPC, true)
		SetPedDiesWhenInjured(MinerNPC, false)
		SetPedCanPlayAmbientAnims(MinerNPC, true)
		SetPedCanRagdollFromPlayerImpact(MinerNPC, false)
		SetEntityInvincible(MinerNPC, true)
		FreezeEntityPosition(MinerNPC, true)
		TaskStartScenarioInPlace(MinerNPC, "WORLD_HUMAN_SMOKING", 0, true);
	spawnNewMarker1()
	while true do
		while newSpawnReady do
			Citizen.Wait(4)
			spawnNewMarker1()
			newSpawnReady = false
			Citizen.Wait(Config.RefreshMarkerTimer)
			newSpawnReady = true
		end
	end
end)

--markers--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		while marker1spawnt do
			local text 		= _U('NP')
			local DTText 	= _U('PPM')
			
			Citizen.Wait(4)
			
			event_destination = Config.mining.MiningPoints[random_destination]
			event_destination2 = Config.mining.MiningPoints2[random_destination2]
			event_destination3 = Config.mining.MiningPoints3[random_destination3]

			local pos = GetEntityCoords(GetPlayerPed(-1), false)
			local dpos = event_destination	
			local dpos2 = event_destination2	
			local dpos3 = event_destination3	
			local delivery_point_distance = Vdist(dpos.x, dpos.y, dpos.z, pos.x, pos.y, pos.z)
			local delivery_point_distance2 = Vdist(dpos2.x, dpos2.y, dpos2.z, pos.x, pos.y, pos.z)
			local delivery_point_distance3 = Vdist(dpos3.x, dpos3.y, dpos3.z, pos.x, pos.y, pos.z)
				
			if delivery_point_distance < 500.0 then
				DrawMarker(1, dpos.x, dpos.y, dpos.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 155, 0, 0, 2, 0, 0, 0, 0)
				DrawMarker(1, dpos2.x, dpos2.y, dpos2.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 155, 0, 0, 2, 0, 0, 0, 0)
				DrawMarker(1, dpos3.x, dpos3.y, dpos3.z,0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 155, 0, 0, 2, 0, 0, 0, 0)
				if delivery_point_distance < 1.5 then
					if isMining == false then
						DrawText3Ds(dpos.x, dpos.y, dpos.z+2, DTText, 0)
							

						if(IsControlJustReleased(1, 38))then
							if pickaxeCounter > 0 then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								if Config.notify == 1 then
									exports['okokNotify']:Alert(
										"Mineria",
										text,
										5000,
										'success'
									)
								elseif Config.notify == 2 then
									TriggerEvent("pNotify:SendNotification", {text = "<span style='font-weight: 900'>" .. text .. "</span>",
									layout = "centerRight",
									timeout = 5000,
									progressBar = false,
									type = "success",
									})
								elseif Config.notify == 3 then 
									TriggerEvent('renzu_notify:Notify','default','Mineria', text)
								elseif Config.notify == 4 then
									TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
								end
							end
								
						end
						

					end
				elseif delivery_point_distance2 < 1.5 then

					if isMining == false then
						DrawText3Ds(dpos2.x, dpos2.y, dpos2.z+2, DTText, 0)
							

						if(IsControlJustReleased(1, 38))then
							if pickaxeCounter > 0 then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								if Config.notify == 1 then
									exports['okokNotify']:Alert(
										"Mineria",
										text,
										5000,
										'success'
									)
								elseif Config.notify == 2 then
									TriggerEvent("pNotify:SendNotification", {text = "<span style='font-weight: 900'>" .. text .. "</span>",
									layout = "centerRight",
									timeout = 5000,
									progressBar = false,
									type = "success",
									})
								elseif Config.notify == 3 then 
									TriggerEvent('renzu_notify:Notify','default','Mineria', text)
								elseif Config.notify == 4 then
									TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
								end
							end
								
						end
						

					end

				elseif delivery_point_distance3 < 1.5 then

					if isMining == false then
						DrawText3Ds(dpos3.x, dpos3.y, dpos3.z+2, DTText, 0)
						
						

						if(IsControlJustReleased(1, 38))then
							if pickaxeCounter > 0 then
								mining()
								TriggerServerEvent("removePickaxe:minerJob")
							else
								if Config.notify == 1 then
									exports['okokNotify']:Alert(
										"Mineria",
										text,
										5000,
										'success'
									)
								elseif Config.notify == 2 then
									TriggerEvent("pNotify:SendNotification", {text = "<span style='font-weight: 900'>" .. text .. "</span>",
									layout = "centerRight",
									timeout = 5000,
									progressBar = false,
									type = "success",
									})
								elseif Config.notify == 3 then 
									TriggerEvent('renzu_notify:Notify','default','Mineria', text)
								elseif Config.notify == 4 then
									TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
								end
							end
								
						end
					end
				end
			end
		end
	end
end)


--events--
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Citizen.Wait(1000)
  	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent("pickaxeBroken:minerJob")
AddEventHandler("pickaxeBroken:minerJob", function()
	--TriggerEvent('notifications', "#29c501", "MINER", "Pickaxe broke")
	local text = _U('PR')
	if Config.notify == 1 then
		exports['okokNotify']:Alert(
       		"Mineria",
			text,
        	5000,
        	'success'
    	)
	elseif Config.notify == 2 then
		TriggerEvent("pNotify:SendNotification", {text = "<span style='font-weight: 900'>" .. text .. "</span>",
        layout = "centerRight",
        timeout = 5000,
        progressBar = false,
        type = "success",
		})
	elseif Config.notify == 3 then 
		TriggerEvent('renzu_notify:Notify','default','Mineria', text)
	elseif Config.notify == 4 then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	end
end)

RegisterNetEvent("showReward:minerJob")
AddEventHandler("showReward:minerJob", function(completReward, EmeraldCount, DiamondCount, ironCount, goldCount)
	local text = _U('RW', completReward) --"Has ganado "..completReward.."€"
	if Config.notify == 1 then
		exports['okokNotify']:Alert(
       		"Mineria",
			text,
        	5000,
        	'success'
    	)
	elseif Config.notify == 2 then
		TriggerEvent("pNotify:SendNotification", {text = "<span style='font-weight: 900'>" .. text .. "</span>",
        layout = "centerRight",
        timeout = 5000,
        progressBar = false,
        type = "success",
		})
	elseif Config.notify == 3 then 
		TriggerEvent('renzu_notify:Notify','default','Mineria', text)
	elseif Config.notify == 4 then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = text, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	end
end)

RegisterNetEvent("refreshDiamond:minerJob")
AddEventHandler("refreshDiamond:minerJob", function(DiamondCount)
	DiamondOresCount = DiamondCount
end)

RegisterNetEvent("refreshGold:minerJob")
AddEventHandler("refreshGold:minerJob", function(EmeraldCount)
	EmeraldOresCount = EmeraldCount
end)

RegisterNetEvent("refreshGold:minerJob")
AddEventHandler("refreshGold:minerJob", function(goldCount)
	goldOresCount = goldCount
end)

RegisterNetEvent("refreshIron:minerJob")
AddEventHandler("refreshIron:minerJob", function(ironCount)
	ironOresCount = ironCount
end)

RegisterNetEvent("refreshPickaxe:minerJob")
AddEventHandler("refreshPickaxe:minerJob", function(pickaxeCount)
	pickaxeCounter = pickaxeCount
end)

--callback
RegisterNUICallback("buyPickAxe", function(data)
	costpickaxe = Config.prices.costpickaxe
	TriggerServerEvent("buyPickAxe:minerJob", costpickaxe)
end)
RegisterNUICallback("buyFood", function(data)
	costfood = Config.prices.costfood
	TriggerServerEvent("buyBread:minerJob", costfood)
end)
RegisterNUICallback("buyWater", function(data)
	costwater = Config.prices.costwater
	TriggerServerEvent("buyWater:minerJob", costwater)
end)
RegisterNUICallback("buyFlash", function(data)
	costFlash = Config.prices.costFlash
	TriggerServerEvent("buyFlash:minerJob", costFlash)
end)
RegisterNUICallback("sellResource", function()
	TriggerServerEvent("sellResource:minerJob")
end)
--very important cb 
RegisterNUICallback("exit", function(data)
   
	SetDisplay(false)
	Citizen.Wait(3000)
	isMenuOn = false
end)

--text--
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3Ds(x, y, z, text, shadow)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = shadow / 370
	if shadow ~= 0 then		
   		DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	end
    ClearDrawOrigin()
end


function create_object()
	local object_model = "prop_air_lights_03a"
	local plyCoords = GetEntityCoords(PlayerPedId(), false)
    RequestModel(object_model)
    while not HasModelLoaded(object_model) do
    	Citizen.Wait(500)				
    end
    local ped = PlayerPedId()
	for i, v in ipairs(Config.lights) do
		local created_object = CreateObjectNoOffset(object_model, v.x, v.y, v.z, 1, 1, 1)
      	PlaceObjectOnGroundProperly(created_object)
      	FreezeEntityPosition(created_object,true)
      	SetModelAsNoLongerNeeded(object_model)
	end
end
