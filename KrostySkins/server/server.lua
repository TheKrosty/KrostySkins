ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 


RegisterServerEvent('Skins:GetSkins')
AddEventHandler('Skins:GetSkins', function(bag)
  local xPlayer = ESX.GetPlayerFromId(source)
  local _source = source
  print(xPlayer.identifier)
  MySQL.Async.fetchAll("SELECT * FROM skins WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
    for i=1,#result do
      TriggerClientEvent('Skins:AddSkins', _source, result[i].bag)
    end
  end)
end)

RegisterServerEvent('Skins:BuySkins')
AddEventHandler('Skins:BuySkins', function(bag)
  local xPlayer = ESX.GetPlayerFromId(source)
  local mymoney = xPlayer.getAccount(Config.Account).money
  local price = Config.Skins[bag].price
  if mymoney >= price then 
    xPlayer.removeAccountMoney(Config.Account, price)
      MySQL.Async.execute("INSERT INTO skins (identifier, bag) VALUES (@identifier, @bag)" , {
        ['@identifier'] = xPlayer.identifier,
        ['@bag'] = bag,
      })
  end
end)

Citizen.CreateThread(function()
  if GetCurrentResourceName() ~= KrostySkins_ then 
        print("[" .. GetCurrentResourceName() .. "] " .. "Thanks for your purchase!")
        print("[" .. GetCurrentResourceName() .. "] " .. "For Support take mi md   By TheKrosty#4329")
    end
end)

Citizen.CreateThread(function()
  if GetCurrentResourceName() ~= KrostySkins_ then 
        print("[" .. GetCurrentResourceName() .. "] " .. "K Shop Top")
    end
end)


--[[ESX.RegisterCommand('giveskin', 'admin', function(source, args)
  local xPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
  TriggerClientEvent('esx:showNotification', source.source, 'Skin entrgada correctamente, ID: '..args[1])
  MySQL.Async.execute("INSERT INTO skins (identifier, bag) VALUES (@identifier, @bag)" , {
    ['@identifier'] = xPlayer.identifier,
    ['@bag'] = tonumber(args[2]),
  })
end)--]]