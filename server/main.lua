ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("buyPickAxe:minerJob")
AddEventHandler("buyPickAxe:minerJob", function(costpickaxe)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(costpickaxe)
    xPlayer.addInventoryItem("pickaxe", 1)
end)


RegisterNetEvent("buyFlash:minerJob")
AddEventHandler("buyFlash:minerJob", function(costFlash)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(costFlash)
    xPlayer.addWeapon("Weapon_flashlight", 1)
end)


RegisterNetEvent("buyBread:minerJob")
AddEventHandler("buyBread:minerJob", function(costfood)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(costfood)
    xPlayer.addInventoryItem("bread", 5)
end)


RegisterNetEvent("buyWater:minerJob")
AddEventHandler("buyWater:minerJob", function(costwater)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeMoney(costwater)
    xPlayer.addInventoryItem("water", 5)
end)


RegisterServerEvent("refreshItems:minerJob") 
AddEventHandler("refreshItems:minerJob", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
    local DiamondCount = xPlayer.getInventoryItem('Diamond').count
    local EmeraldCount = xPlayer.getInventoryItem('Emerald').count
	local goldCount = xPlayer.getInventoryItem('gold').count
	local ironCount = xPlayer.getInventoryItem('iron').count
	local pickaxeCount = xPlayer.getInventoryItem('pickaxe').count
    
    
    TriggerClientEvent("refreshDiamond:minerJob", source, DiamondCount)
    TriggerClientEvent("refreshEmerald:minerjob", source, EmeraldCount)
    TriggerClientEvent("refreshGold:minerJob", source, goldCount)
    TriggerClientEvent("refreshIron:minerJob", source, ironCount)
    TriggerClientEvent("refreshPickaxe:minerJob", source, pickaxeCount)
    if Config.enablelogs then
        text = _U('RIMJ',GetPlayerName(source),ironCount, goldCount ,DiamondCount ,EmeraldCount)
        exports.JD_logs:createLog({
            EmbedMessage = text,
            color = "#FFFFFF",
            player_id = source,
            channel = Config.logschanel,
            screenshot = false
        })
        if Config.enabledebug then
            print(text)
        end
    end
end)


RegisterNetEvent("sellResource:minerJob")
AddEventHandler("sellResource:minerJob", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    local EmeraldCount = xPlayer.getInventoryItem('Emerald').count
    local DiamondCount = xPlayer.getInventoryItem('Diamond').count
    local goldCount = xPlayer.getInventoryItem('gold').count
    local ironCount = xPlayer.getInventoryItem('iron').count

    local randomDiamondCash = math.random(Config.prices.Diamond.min, Config.prices.Diamond.max)
    local randomEmeraldCash = math.random(Config.prices.Emerald.min, Config.prices.Emerald.max)
    local randomGoldCash = math.random(Config.prices.Gold.min, Config.prices.Gold.max)
    local randomIronCash = math.random(Config.prices.Iron.min, Config.prices.Iron.max)

    local EmeraldReward = EmeraldCount * randomEmeraldCash
    local DiamondReward = DiamondCount * randomDiamondCash
    local goldReward = goldCount * randomGoldCash
    local ironReward = ironCount * randomIronCash
    local completReward = goldReward + ironReward + DiamondReward + EmeraldReward

    if EmeraldCount >= 0 and DiamondCount >= 0 and goldCount >= 0 and ironCount >= 0 then
        if ironCount > 0 and goldCount > 0 and DiamondCount and EmeraldCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("iron", ironCount)
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif ironCount > 0 and goldCount > 0 and DiamondCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("iron", ironCount)
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
        elseif ironCount > 0 and goldCount > 0 and EmeraldCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("iron", ironCount)
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif ironCount > 0 and DiamondCount > 0 then
            xPlayer.removeInventoryItem("iron", ironCount)
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
        elseif ironCount > 0 and goldCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("iron", ironCount)
        elseif ironCount > 0 and EmeraldCount > 0 then
            xPlayer.removeInventoryItem("iron", ironCount)
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif goldCount > 0 and DiamondCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
        elseif goldCount > 0 and EmeraldCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif DiamondCount > 0 and EmeraldCount > 0 then
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif EmeraldCount > 0 then
            xPlayer.removeInventoryItem("Emerald", EmeraldCount)
        elseif DiamondCount > 0 then 
            xPlayer.removeInventoryItem("Diamond", DiamondCount)
        elseif goldCount > 0 then
            xPlayer.removeInventoryItem("gold", goldCount)
        elseif ironCount > 0 then
            xPlayer.removeInventoryItem("iron", ironCount)
        end
        xPlayer.addMoney(completReward) 
    end

    if completReward >= 0 then
        TriggerClientEvent("showReward:minerJob", source, completReward, EmeraldCount, DiamondCount, ironCount, goldCount)
    end
end)


RegisterNetEvent("addItems:minerJob")
AddEventHandler("addItems:minerJob", function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local randomItem = math.random(1,100)
    if Config.enabledebug then
        print("Picar -->"..randomItem.."")
    end
    
    
    local randomeIronCounter = math.random(Config.amount.Iron.min, Config.amount.Iron.max)
    local randomegoldCounter = math.random(Config.amount.Gold.min, Config.amount.Gold.max)
    local randomeDiamondCounter = math.random(Config.amount.Diamond.min, Config.amount.Diamond.max)
    local randomeEmeraldCounter = math.random(Config.amount.Emerald.min, Config.amount.Emerald.max)

    if randomItem < 65 then
        xPlayer.addInventoryItem("iron", randomeIronCounter)
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = ""..GetPlayerName(source).. " Esta minando con una probabilidad de "..randomItem.." y le a tocado Hierro. Con una cantidad de "..randomeIronCounter,
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })
        end
    elseif randomItem < 85 then
        xPlayer.addInventoryItem("gold", randomegoldCounter)
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = ""..GetPlayerName(source).. " Esta minando con una probabilidad de "..randomItem.." y le a tocado ORO. Con una cantidad de "..randomegoldCounter,
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })
        end
    elseif randomItem > 85 then
        xPlayer.addInventoryItem("Diamond", randomeDiamondCounter)
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = ""..GetPlayerName(source).. " Esta minando con una probabilidad de "..randomItem.." y le a tocado Diamante. Con una cantidad de "..randomeDiamondCounter,
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })
        end
    elseif randomItem > 95 then 
        xPlayer.addInventoryItem("Emerald", randomeEmeraldCounter)
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = "" ..GetPlayerName(source).. " Esta minando con una probabilidad de "..randomItem.." y le a tocado Esmeralda. Con una cantidad de "..randomeEmeraldCounter,
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })
        end
    end
end)


RegisterNetEvent("removePickaxe:minerJob")
AddEventHandler("removePickaxe:minerJob", function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local randomDestroy = math.random(1,100)
    if Config.enabledebug then
        print("pico -->" ..randomDestroy.."")
    end
    if randomDestroy < 80 then
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = ""..GetPlayerName(source).. " No se le rompio pero estuvo a "..randomDestroy.." de 80",
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })  
        end
    else
        TriggerClientEvent("pickaxeBroken:minerJob", source)
        xPlayer.removeInventoryItem("pickaxe", 1)
        if Config.enablelogs then
            exports.JD_logs:createLog({
                EmbedMessage = ""..GetPlayerName(source).. " Se le rompio el pico. "..randomDestroy,
                color = "#FFFFFF",
                player_id = source,
                channel = Config.logschanel,
                screenshot = false
            })
        end
    end

end)

  
Citizen.CreateThread( function()
    while true do
        updatePath = "/troner14/Troner14-MinerJob-version" -- your git user/repo path
        resourceName = "Troner14-MinerJob-version ("..GetCurrentResourceName()..")" -- the resource name
        discord = "https://github.com/troner14/Troner14_Minerjob"
        
        function checkVersion(err,responseText, headers)
            curVersion = Config.Version -- make sure the "version" file actually exists in your resource root!
            
            if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
                print("\n###############################")
                print("\n"..resourceName.." está desactualizado,\ndebería ser:"..responseText.."y estas:"..curVersion.."\npor favor actualícelo desde "..discord)
                print("\n###############################")
                print('SCRIPT CON COPYRIGHT')
                print('𝕋𝕣𝕠𝕟𝕖𝕣𝟙𝟜-𝕄𝕚𝕟𝕖𝕣𝕛𝕠𝕓 © 2021-2022 by Troner14 is licensed under CC BY-NC-ND 4.0 ')
            elseif tonumber(curVersion) > tonumber(responseText) then
                print("De alguna manera te saltaste algunas versiones de "..resourceName.." o el git se desconectó, si está en línea, le aconsejo que actualice (¿o rebaje?)")
                print('SCRIPT CON COPYRIGHT')
                print('𝕋𝕣𝕠𝕟𝕖𝕣𝟙𝟜-𝕄𝕚𝕟𝕖𝕣𝕛𝕠𝕓 © 2021-2022 by Troner14 is licensed under CC BY-NC-ND 4.0 ')
            else
                print("\n"..resourceName.." Estas en la version correcta")
                print('SCRIPT CON COPYRIGHT')
                print('𝕋𝕣𝕠𝕟𝕖𝕣𝟙𝟜-𝕄𝕚𝕟𝕖𝕣𝕛𝕠𝕓 © 2021-2022 by Troner14 is licensed under CC BY-NC-ND 4.0 ')
            end
        end
            
        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
        Citizen.Wait(3600000)
    end   
end)
