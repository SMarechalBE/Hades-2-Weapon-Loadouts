---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

local function AssertGameState()
	if not game.GameState then
		modutil.mod.Print("ERROR! GameState corrupted!")
		return false
	end

	return true
end

local function ConcatStrToTable(str)
	local t = {}
	str:gsub("%a+", function(v)
		table.insert(t, v)
	end)

	return t
end

local function EnableLoadoutBox(screen)
	game.SetAlpha({
		Id = screen.Components.LoadoutBox.Id,
		Fraction = 1.0,
		Duration = 0.0,
	})
end

local function DisableLoadoutBox(screen)
	game.SetAlpha({
		Id = screen.Components.LoadoutBox.Id,
		Fraction = 0.0,
		Duration = 0.0,
	})
end

--#region Weapon

---Get current Weapon
---@return string? weapon
---@return string? aspect
local function GetWeapon()
	if not AssertGameState() then
		return
	end

	return game.GameState.PrimaryWeaponName
end

---Get current Aspect
---@param weapon string
---@return string? aspect
local function GetAspect(weapon)
	if not AssertGameState() then
		return
	end

	return game.GameState.LastWeaponUpgradeName and game.GameState.LastWeaponUpgradeName[weapon]
end

local function PrintWeapon(weapon)
	weapon = weapon or "Error"
	modutil.mod.Print("  Weapon: " .. weapon)
end

local function PrintAspect(aspect)
	aspect = aspect or "Error"
	modutil.mod.Print("  Aspect: " .. aspect)
end
--#endregion Weapon

--#region Pinned Boons

---Load pinned boons
---@param boonsStr string
local function LoadPinnedBoons(boonsStr)
	if not AssertGameState() then
		return
	end

	-- Remove all currently pinned boons
	for i = 1, #game.GameState.StoreItemPins do
		if game.GameState.StoreItemPins[i].StoreName == "TraitData" then
			game.GameState.StoreItemPins[i] = nil
		end
	end
	game.GameState.StoreItemPins = game.CollapseTable(game.GameState.StoreItemPins) -- collapse ensures we can call ipairs on the table without issue

	local boons = {}
	boonsStr:gsub("%a+", function(boon)
		table.insert(boons, boon)
	end)

	-- Add given boons to the pinned boons
	boons = boons or {}
	for _, boon in pairs(boons) do
		game.AddStoreItemPin(boon, "TraitData")
	end
end

local function GetPinnedBoons()
	if not AssertGameState() then
		return
	end

	local boons = {}
	local storeItemPins = game.GameState.StoreItemPins or {}
	for _, pin in pairs(storeItemPins) do
		if pin.StoreName == "TraitData" then
			table.insert(boons, pin.Name)
		end
	end

	-- return boons
	return table.concat(boons, ",")
end

local function PrintPinnedBoons(boons)
	-- boons = boons or {"Error"}
	-- modutil.mod.Print("Pinned Boons: " .. table.concat(boons, ","))
	boons = boons or ""
	modutil.mod.Print("  Pinned Boons: " .. boons)
end

function PinnedBoonsStartFunction(screen, aspectName)
	modutil.mod.Print("PinnedBoonsStartFunction: WIP")
end
function PinnedBoonsEndFunction(screen, aspectName)
	modutil.mod.Print("PinnedBoonsEndFunction: WIP")
end

--#endregion Pinned Boons

--#region Keepsakes
local function GetAspectKeepsakes(aspectName)
	if not config.Loadout[aspectName].Saved then
		return {}
	end

	return ConcatStrToTable(config.Loadout[aspectName].Keepsakes)
end

local function GetKeepsakes()
	local keepsakesLookup = startingKeepsakes.config and startingKeepsakes.config.keepsakes
	if not keepsakesLookup then
		modutil.mod.Print("Error: couldn't load keepsakes config")
		return {}
	end

	local keepsakes = {}
	for keepsake, enabled in pairs(keepsakesLookup) do
		if enabled then
			table.insert(keepsakes, keepsake)
		end
	end
	return table.concat(keepsakes, ",")
end

local function LoadKeepsakes(keepsakesStr)
	local keepsakesLookup = startingKeepsakes.config and startingKeepsakes.config.keepsakes
	if not keepsakesLookup then
		modutil.mod.Print("Error: couldn't load keepsakes config")
		return
	end

	for keepsake, _ in pairs(keepsakesLookup) do
		keepsakesLookup[keepsake] = false
	end

	local keepsakes = {}
	keepsakesStr:gsub("%a+", function(keepsake)
		table.insert(keepsakes, keepsake)
	end)

	for _, keepsake in pairs(keepsakes) do
		keepsakesLookup[keepsake] = true
	end
end

local function PrintKeepsakes(keepsakes)
	keepsakes = keepsakes or "Error"
	modutil.mod.Print("  Keepsakes: " .. keepsakes)
end

local function CreateKeepsakeIcons(screen, aspectName)
	screen.KeepsakeIconIds = {}

	local traitSpacingX = 80
	local traitSpacingY = 120
	local traitStartX = 40
	local traitStartY = 80

	local iconScale = 0.5

	local keepsakes = GetAspectKeepsakes(aspectName)

	local yOffset = traitStartY
	for r = 1, 5 do
		local xOffset = traitStartX
		for c = 1, 5 do
			local traitName = keepsakes[((r - 1) * 5) + c]
			local traitData = traitName and game.TraitData[traitName]
			if not traitData then
				return
			end
			local traitIcon = game.CreateScreenComponent({
				Name = "TraitTrayIconButton",
				X = xOffset,
				Y = yOffset,
				Group = screen.ComponentData.DefaultGroup,
				Scale = iconScale,
				Animation = game.GetTraitIcon(traitData),
				Alpha = 1.0,
			})

			table.insert(screen.Components, traitIcon)
			table.insert(screen.KeepsakeIconIds, traitIcon.Id)

			xOffset = xOffset + traitSpacingX
		end
		yOffset = yOffset + traitSpacingY
	end
end
local function DestroyKeepsakeIcons(screen)
	if screen.KeepsakeIconIds and type(screen.KeepsakeIconIds) == "table" then
		game.Destroy({ Ids = screen.KeepsakeIconIds })
	end
	screen.KeepsakeIconIds = {}
end

function KeepsakesStartFunction(screen, aspectName)
	modutil.mod.Print("KeepsakesStartFunction: WIP")
	EnableLoadoutBox(screen)
	CreateKeepsakeIcons(screen, screen.ClipboardText)
end

function KeepsakesEndFunction(screen, aspectName)
	modutil.mod.Print("KeepsakesEndFunction: WIP")
	DisableLoadoutBox(screen)
	DestroyKeepsakeIcons(screen)
end

--#endregion Keepsakes

--#region Familiar
local function GetFamiliar()
	if not AssertGameState() then
		return
	end

	return game.GameState.EquippedFamiliar
end

local function LoadFamiliar(familiarName)
	local familiar = game.FamiliarData and game.FamiliarData[familiarName]
	if not familiar then
		modutil.mod.Print("ERROR! Can't load familiar data for " .. tostring(familiarName))
		return
	end

	game.UseFamiliar(familiar)
end

local function PrintFamiliar(familiarName)
	familiarName = familiarName or "Error"
	modutil.mod.Print("  Familiar: " .. familiarName)
end

function FamiliarsStartFunction(screen, aspectName)
	modutil.mod.Print("FamiliarsStartFunction: WIP")
end

function FamiliarsEndFunction(screen, aspectName)
	modutil.mod.Print("FamiliarsEndFunction: WIP")
end

--#endregion Familiar

--#region Arcanas
local function GetArcanas()
	if not AssertGameState() then
		return
	end

	local arcanas = {}
	for arcana, state in pairs(game.GameState.MetaUpgradeState) do
		if state and state.Equipped then
			table.insert(arcanas, arcana)
		end
	end

	return table.concat(arcanas, ",")
end

local function GetAspectArcanas(aspectName)
	if not config.Loadout[aspectName].Saved then
		return {}
	end

	return ConcatStrToTable(config.Loadout[aspectName].Arcanas)
end

local function LoadArcanas(arcanasStr)
	if not AssertGameState() then
		return
	end

	-- Unequip all arcanas
	for metaUpgradeName, _ in pairs(game.GameState.MetaUpgradeState) do
		game.GameState.MetaUpgradeState[metaUpgradeName].Equipped = false
	end

	-- Equip specified arcanas (if unlocked)
	local arcanas = ArcanasStrToTable(arcanasStr)
	for _, arcana in pairs(arcanas) do
		local metaUpgradeState = game.GameState.MetaUpgradeState[arcana]
		if metaUpgradeState and metaUpgradeState.Unlocked then
			metaUpgradeState.Equipped = true
		else
			modutil.mod.Print("Skipped " .. arcana .. " as it is locked or undefined")
		end
	end

	-- This getter has the side effect of setting GameState.MetaUpgradeCostCache
	game.GetCurrentMetaUpgradeCost()
end

local function PrintArcanas(arcanas)
	arcanas = arcanas or ""
	modutil.mod.Print("  Arcanas: " .. arcanas)
end

local function DisplayArcanasIcons(screen)
	if not screen then
		modutil.mod.Print("Error: screen is nil, can't display arcana icons")
		return
	end

	screen.ArcanaIconIds = {}

	local traitSpacingX = 80
	local traitSpacingY = 120
	local traitStartX = 40
	local traitStartY = 80

	local iconScale = 0.18

	local yOffset = traitStartY
	for _, row in ipairs(game.MetaUpgradeDefaultCardLayout) do
		local xOffset = traitStartX
		for _, arcanaName in ipairs(row) do
			local metaUpgradeCardData = game.MetaUpgradeCardData[arcanaName]

			-- TODO: handle locked arcanas, grey them out
			local traitIcon = game.CreateScreenComponent({
				Name = "TraitTrayIconButton",
				X = xOffset,
				Y = yOffset,
				Group = screen.ComponentData.DefaultGroup,
				Animation = metaUpgradeCardData.Image,
				Scale = iconScale,
				Alpha = 1.0,
			})

			table.insert(screen.Components, traitIcon)
			screen.ArcanaIconIds[arcanaName] = traitIcon.Id

			xOffset = xOffset + traitSpacingX
		end
		yOffset = yOffset + traitSpacingY
	end
end

local function EnableArcanaIcons(screen)
	if game.TableLength(screen.ArcanaIconIds, true) == 0 then
		DisplayArcanasIcons(screen)
		return
	end

	for _, id in pairs(screen.ArcanaIconIds) do
		game.SetAlpha({ Id = id, Fraction = 1.0, Duration = 0.0 })
	end
end

local function DisableArcanaIcons(screen)
	for _, id in pairs(screen.ArcanaIconIds) do
		game.SetAlpha({ Id = id, Fraction = 0.0, Duration = 0.0 })
	end
end

local function LinkArcanaFrames(screen, aspectName)
	screen.ArcanaFrameIds = {}

	local loadoutArcanas = GetAspectArcanas(aspectName)
	for _, arcanaName in ipairs(loadoutArcanas) do
		local traitIconId = screen.ArcanaIconIds and screen.ArcanaIconIds[arcanaName]
		if traitIconId then
			local traitFrameId = game.CreateScreenObstacle({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				Scale = 0.6,
				Alpha = 1.0,
			})
			game.SetAnimation({ Name = "DevCard_EquippedHighlight", DestinationId = traitFrameId })
			game.Attach({ Id = traitFrameId, DestinationId = traitIconId })

			table.insert(screen.ArcanaFrameIds, traitFrameId)
		else
			modutil.mod.Print("Error: can't get trait icon id for " .. arcanaName)
		end
	end
end

local function DestroyArcanaFrames(screen)
	if screen.ArcanaFrameIds and type(screen.ArcanaFrameIds) == "table" then
		game.Destroy({ Ids = screen.ArcanaFrameIds })
	end
	screen.ArcanaFrameIds = {}
end

function ArcanasStartFunction(screen, aspectName)
	EnableLoadoutBox(screen)
	EnableArcanaIcons(screen)
	LinkArcanaFrames(screen, screen.ClipboardText)
end

function ArcanasEndFunction(screen, aspectName)
	DisableLoadoutBox(screen)
	DisableArcanaIcons(screen)
	DestroyArcanaFrames(screen)
end

--#endregion Arcanas

--#region Fear Oaths
local function GetFearOaths()
	modutil.mod.Print("Fear oaths are a WIP")
end

local function LoadFearOaths(oaths)
	modutil.mod.Print("Fear oaths are a WIP")
	-- game.GameState.ShrineUpgrades = StoredGameState.ShrineUpgrades
	-- game.GameState.SpentShrinePointsCache = game.GetTotalSpentShrinePoints()
end

local function PrintFearOaths(oaths)
	modutil.mod.Print("Fear oaths are a WIP")
end
--#endregion Fear Oaths

function PrintLoadout(aspect, loadout)
	modutil.mod.Print("Loadout:")
	PrintWeapon(GetWeapon())
	PrintAspect(aspect)
	PrintPinnedBoons(loadout.Boons)
	PrintKeepsakes(loadout.Keepsakes)
	PrintFamiliar(loadout.Familiar)
	PrintArcanas(loadout.Arcanas)
	PrintFearOaths(loadout.FearOaths)
end

function IsLoadoutSaved(aspect)
	return config.Loadout and config.Loadout[aspect] and config.Loadout[aspect].Saved
end

---comment
---@param aspect string
function SaveLoadout(aspect)
	if not AssertGameState() then
		return
	end

	config.Loadout[aspect] = {
		Saved = true,
		Boons = GetPinnedBoons(),
		Keepsakes = GetKeepsakes(),
		Familiar = GetFamiliar(),
		Arcanas = GetArcanas(),
		FearOaths = GetFearOaths(),
	}
end

function RestoreLoadout(aspect)
	if not AssertGameState() then
		return
	end

	local loadout = config.Loadout[aspect]
	if not loadout then
		modutil.mod.Print("No loadout to restore")
		return
	end

	LoadPinnedBoons(loadout.Boons)
	LoadKeepsakes(loadout.Keepsakes)
	LoadFamiliar(loadout.Familiar)
	LoadArcanas(loadout.Arcanas)
	LoadFearOaths(loadout.FearOaths)
end

function DefaultModelStartFunction(screen, aspectName)
	game.SetAlpha({
		Id = screen.Components.WeaponImage.Id,
		Fraction = 1.0,
		Duration = 0.0,
	})
end

function DefaultModelEndFunction(screen, aspectName)
	game.SetAlpha({
		Id = screen.Components.WeaponImage.Id,
		Fraction = 0.0,
		Duration = 0.0,
	})
end
