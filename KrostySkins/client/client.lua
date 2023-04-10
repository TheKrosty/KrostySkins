MySkins = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
	armas = ESX.GetWeaponList()
end)


function OpenSkinsMenu()
	TriggerServerEvent('Skins:GetSkins')
	local elements = {
		{label = 'Mis Skins', value = '1'},
		{label = 'Comprar Skins', value = '2'},
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mainmenu', {
		title    = 'Skins',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == '1' then
			OpenOwnedSkinsMenu()
		elseif data.current.value == '2' then 
			OpenBuySkinsMenu()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenOwnedSkinsMenu()
	local elements = {
		{label = "Tintes", value = 'individual'},
		{label = "Grabados", value = 'online'},
	--	{label = "Skins MK2", value = 'mk2'},
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskins', {
		title    = 'Mis Skins',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'individual' then
			OpenIndividualSkins()
		elseif data.current.value == 'online' then
			OpenOnlineSkins()
	--	elseif data.current.value == 'mk2' then
	--		OpenMK2Skins()
		end
	end, function(data, menu)
		menu.close()
	end)
end

OpenIndividualSkins = function()
	local elements = {}
	table.insert(elements, {label = "Normal", value = 'default'})
	
	for i=1,#Config.Skins do
		if MySkins[i] and not Config.Skins[i].varmod and not Config.Skins[i].mk2 and not Config.Skins[i].mk2page2 then
			table.insert(elements, {label = Config.Skins[i].name, value = i})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskinsindividual', {
		title    = 'Tintes',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'default' then
			RemoveSingleSkin()
		else
			ApplySingleSkin(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

OpenOnlineSkins = function()
	local elements = {}
	table.insert(elements, {label = "Normal", value = 'skindefault'})
	for i=1,#Config.Skins do
		if MySkins[i] and Config.Skins[i].varmod then
			table.insert(elements, {label = Config.Skins[i].name, value = i})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskinsonline', {
		title    = 'Grabados',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'skindefault' then
			RemoveOnlineSkin()
		else
			ApplyOnlineSkin(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

--[[OpenMK2Skins = function()
	local elements = {
		{label = 'Tintes', value = 'page1'},
		{label = 'Skins', value = 'page2'}
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskinsmk2', {
		title    = 'Skins MK2',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
			if data.current.value == 'page1' then
				OpenOwnedMk2SkinPage1()
			elseif data.current.value == 'page2' then
				OpenOwnedMk2SkinPage2()
			end
	end, function(data, menu)
		menu.close()
	end)
end

OpenOwnedMk2SkinPage1 = function()
	local elements = {}
	table.insert(elements, {label = "Normal", value = 'skindefault'})
	for i=1,#Config.Skins do
		if MySkins[i] and Config.Skins[i].mk2 then
			table.insert(elements, {label = Config.Skins[i].name, value = i})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskinsmk2page1', {
		title    = 'Tintes MK2',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'skindefault' then
			RemoveSingleSkin()
		else
			ApplySingleSkin(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

OpenOwnedMk2SkinPage2 = function()
	local elements = {}
	table.insert(elements, {label = "Normal", value = 'skindefault'})
	for i=1,#Config.Skins do
		if MySkins[i] and Config.Skins[i].mk2page2 then
			table.insert(elements, {label = Config.Skins[i].name, value = i})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myskinsmk2page2', {
		title    = 'Skins MK2',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'skindefault' then
			RemoveMK2Skin()
		else
			ApplyMK2Skin(data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end]]

function RemoveOnlineSkin(id)
    local ped = PlayerPedId()
    local hash = GetSelectedPedWeapon(ped)
    local weapon = GetWeaponFromHash(hash)
    local component = weapon:gsub('WEAPON_', 'COMPONENT_')
    for i=1,#Config.Skins do
        if Config.Skins[i].varmod then
            local component = component.."_VARMOD_"..Config.Skins[i].varmod
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(component))
        end
    end
end

--[[function RemoveMK2Skin(id)
    local ped = PlayerPedId()
    local hash = GetSelectedPedWeapon(ped)
    local weapon = GetWeaponFromHash(hash)
    local component = weapon:gsub('WEAPON_', 'COMPONENT_')
    for i=1,#Config.Skins do
        if Config.Skins[i].mk2page2 then
            local component = component..Config.Skins[i].mk2page2
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(component))
        end
    end
end ]]

function RemoveSingleSkin(id)
  local ped = PlayerPedId()
  local hash = GetSelectedPedWeapon(ped)
  local weapon = GetWeaponFromHash(hash)
  SetPedWeaponTintIndex(GetPlayerPed(-1), GetHashKey(weapon), 0)
end

function ApplySingleSkin(id)
	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local weapon = GetWeaponFromHash(hash)
	SetPedWeaponTintIndex(GetPlayerPed(-1), GetHashKey(weapon), Config.Skins[id].id)
end

function ApplyOnlineSkin(id)
	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local weapon = GetWeaponFromHash(hash)
	local component = weapon:gsub('WEAPON_', 'COMPONENT_')
	local component = component.."_VARMOD_"..Config.Skins[id].varmod
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weapon), GetHashKey(component))
end

function ApplyMK2Skin(id)
	local ped = PlayerPedId()
	local hash = GetSelectedPedWeapon(ped)
	local weapon = GetWeaponFromHash(hash)
	local component = weapon:gsub('WEAPON_', 'COMPONENT_')
	local component = component..Config.Skins[id].mk2page2
	GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(weapon), GetHashKey(component))
end

function GetWeaponFromHash(hash)
  for name,item in pairs(armas) do
    if hash == GetHashKey(item.name) then
      return item.name
      end
  end
end

OpenBuySingleSkins = function()
	local elements = {}
	for i=1,#Config.Skins do
		if Config.Skins[i].singleplayer and not Config.Skins[i].exclusive and not MySkins[i] then 
			table.insert(elements, {label = Config.Skins[i].name.. ' -<span style="color:orange;"> '..Config.Skins[i].price..' Estrellas</span>', value = i})
		end
	end
	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todas las skins!</span>', value = ''})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buysingleskins',{
		title = "Comprar Tintes",
		align = "bottom-right",
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Skins:BuySkins', data.current.value)
		OpenSkinsMenu()
	end, function(data, menu)
		menu.close()
	end)
end

OpenBuyOnlineSkins = function()
	local elements = {}
	for i=1,#Config.Skins do
		if Config.Skins[i].varmod and not MySkins[i] then 
			table.insert(elements, {label = Config.Skins[i].name.. ' -<span style="color:orange;"> '..Config.Skins[i].price..' Estrellas</span>', value = i})
		end
	end
	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todas las skins!</span>', value = ''})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buyonlineskins',{
		title = "Comprar Grabados",
		align = "bottom-right",
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Skins:BuySkins', data.current.value)
		OpenSkinsMenu()
	end, function(data, menu)
		menu.close()
	end)
end

--[[OpenBuyMk2SkinsPage1 = function()
	local elements = {}
	for i=1,#Config.Skins do
		if Config.Skins[i].mk2 and not MySkins[i] then 
			table.insert(elements, {label = Config.Skins[i].name.. ' -<span style="color:orange;"> '..Config.Skins[i].price..' PicaoCoin</span>', value = i})
		end
	end
	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todas las skins!</span>', value = ''})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buymk2skinspage1',{
		title = "MK2 - Tintes",
		align = "bottom-right",
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Skins:BuySkins', data.current.value)
		OpenSkinsMenu()
	end, function(data, menu)
		menu.close()
	end)
end

OpenBuyMk2SkinsPage2 = function()
	local elements = {}
	for i=1,#Config.Skins do
		if Config.Skins[i].mk2page2 and not MySkins[i] then 
			table.insert(elements, {label = Config.Skins[i].name.. ' -<span style="color:orange;"> '..Config.Skins[i].price..' PicaoCoin</span>', value = i})
		end
	end
	if not elements[1] then 
		table.insert(elements, {label = '<span style="color:#67009e;">Ya tienes todas las skins!</span>', value = ''})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buymk2skinspage2',{
		title = "MK2 - Skins",
		align = "bottom-right",
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('Skins:BuySkins', data.current.value)
		OpenSkinsMenu()
	end, function(data, menu)
		menu.close()
	end)
end

OpenBuyMk2Skins = function()
	local elements = {
		{label = 'Tintes', value = 'page1'},
		{label = 'Skins', value = 'page2'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buymk2skins',{
		title = "Comprar Skins MK2",
		align = "bottom-right",
		elements = elements
	}, function(data, menu)
		if data.current.value == 'page1' then
			OpenBuyMk2SkinsPage1()
		elseif data.current.value == 'page2' then
			OpenBuyMk2SkinsPage2()
		end
	end, function(data, menu)
		menu.close()
	end)
end --]]

function OpenBuySkinsMenu()
	local elements = {
		{label = "Tintes", value = 'singleskins'},
		{label = "Grabados",       value = 'onlineskins'},
	--	{label = "Skins MK2",          value = 'mk2skins'},
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buyskins', {
		title    = 'Comprar Skins',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'singleskins' then
			OpenBuySingleSkins()
		elseif data.current.value == 'onlineskins' then
			OpenBuyOnlineSkins()
		elseif data.current.value == 'mk2skins' then
			OpenBuyMk2Skins()
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterCommand('skins', function()
	OpenSkinsMenu()
end)

RegisterNetEvent('Skins:AddSkins')
AddEventHandler('Skins:AddSkins', function(skin)
	MySkins[skin] = true
end)