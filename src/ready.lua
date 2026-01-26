---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

local WeaponUpgradeScreenComponents = {

	LoadoutBox = {
		AnimationName = "GUI\\HUD\\TraitTrayBacking_NoHeader",
		X = 202,
		Y = 320,
		Scale = 0.43,
		Alpha = 0.0,
		-- AlphaTarget = 1.0,
		-- AlphaTargetDuration = 0.4,
	},

	ActionBar = {
		ChildrenOrder = {
			"CloseButton",
			"SelectButton",
			"EmptyButton",
			"RestoreLoadoutButton",
			"SaveLoadoutButton",
		},
		Children = {

			EmptyButton = { -- For some padding
				Graphic = "ContextualActionButton",
				Data = {},
				TextArgs = UIData.ContextualButtonFormatRight,
			},

			RestoreLoadoutButton = {
				Graphic = "ContextualActionButton",
				Data = {
					OnPressedFunctionName = _PLUGIN.guid .. "." .. "RestoreLoadoutButton",
					ControlHotkeys = { "ItemPin" },
				},
				Text = "{IP} RESTORE",
				TextArgs = UIData.ContextualButtonFormatRight,
			},

			SaveLoadoutButton = {
				Graphic = "ContextualActionButton",
				Data = {
					OnPressedFunctionName = _PLUGIN.guid .. "." .. "SaveLoadoutButton",
					ControlHotkeys = { "Confirm" },
				},
				Text = "{CF} SAVE LOADOUT",
				TextArgs = UIData.ContextualButtonFormatRight,
			},

			-- LoadoutLabel = {
			-- 	Graphic = "ContextualActionButton",
			-- 	Data = {},
			-- 	Text = "LOADOUT:",
			-- 	TextArgs = UIData.ContextualButtonFormatRight,
			-- },
		},
	},

	LeftActionBar = {
		X = UIData.ContextualButtonXLeft,
		Y = UIData.ContextualButtonY,
		AutoAlignContextualButtons = true,
		AutoAlignJustification = "Left",

		ChildrenOrder = {
			"PreviousTraitShow",
			"NextTraitShow",
		},

		Children = {
			NextTraitShow = {
				Graphic = "ContextualActionButton",
				Data = {
					OnPressedFunctionName = _PLUGIN.guid .. "." .. "NextTraitShowButton",
					ControlHotkeys = { "NextLayout" },
				},
				Text = "{NL} NEXT SET",
				TextArgs = UIData.ContextualButtonFormatLeft,
			},

			PreviousTraitShow = {
				Graphic = "ContextualActionButton",
				Data = {
					OnPressedFunctionName = _PLUGIN.guid .. "." .. "PreviousTraitShowButton",
					ControlHotkeys = { "PrevLayout" },
				},
				Text = "{PL} PREVIOUS SET",
				TextArgs = UIData.ContextualButtonFormatLeft,
			},
		},
	},
}
modutil.mod.Table.Merge(game.ScreenData.WeaponUpgradeScreen.ComponentData, WeaponUpgradeScreenComponents)

function mod.SaveLoadoutButton(screen, button)
	-- For some reason, MouseOverWeaponUpgrade sets this value
	local aspect = screen.ClipboardText
	SaveLoadout(aspect)

	local componentId = screen.Components
		and screen.Components.RestoreLoadoutButton
		and screen.Components.RestoreLoadoutButton.Id
	game.SetAlpha({ Id = componentId, Fraction = 1, Duration = 0.1 })
	game.UseableOff({ Id = componentId })
end

function mod.RestoreLoadoutButton(screen, button)
	-- For some reason, MouseOverWeaponUpgrade sets this value
	local aspect = screen.ClipboardText
	RestoreLoadout(aspect)
end

local AspectLoadout = {
	Categories = {
		Order = {
			"DefaultModel",
			"Arcanas",
			"Traits",
		},

		DefaultModel = {
			StartFunction = function(...)
				DefaultModelStartFunction(...)
			end,
			EndFunction = function(...)
				DefaultModelEndFunction(...)
			end,
		},

		Arcanas = {
			StartFunction = function(...)
				ArcanasStartFunction(...)
			end,
			EndFunction = function(...)
				ArcanasEndFunction(...)
			end,
		},

		Traits = {
			StartFunction = function(...)
				TraitsStartFunction(...)
			end,
			EndFunction = function(...)
				TraitsEndFunction(...)
			end,
		},
	},
	CurrentIndex = 1,
}

local function GetCurrentCategory()
	return AspectLoadout.Categories.Order[AspectLoadout.CurrentIndex]
end

local function CallCurrentCategoryStartFunction(screen, aspectName)
	local category = AspectLoadout.Categories[GetCurrentCategory()]
	if category and category.StartFunction then
		category.StartFunction(screen, aspectName)
	end
end

local function CallCurrentCategoryEndFunction(screen, aspectName)
	local category = AspectLoadout.Categories[GetCurrentCategory()]
	if category and category.EndFunction then
		category.EndFunction(screen, aspectName)
	end
end

function mod.NextTraitShowButton(screen, button)
	local aspectName = screen.ClipboardText
	CallCurrentCategoryEndFunction(screen, aspectName)
	local idx = AspectLoadout.CurrentIndex
	AspectLoadout.CurrentIndex = idx == #AspectLoadout.Categories.Order and 1 or idx + 1
	CallCurrentCategoryStartFunction(screen, aspectName)
end

function mod.PreviousTraitShowButton(screen, button)
	local aspectName = screen.ClipboardText
	CallCurrentCategoryEndFunction(screen, aspectName)
	local idx = AspectLoadout.CurrentIndex
	AspectLoadout.CurrentIndex = idx == 1 and #AspectLoadout.Categories.Order or idx - 1
	CallCurrentCategoryStartFunction(screen, aspectName)
end

modutil.mod.Path.Wrap("MouseOverWeaponUpgrade", function(base, button)
	local returnValue = base(button)

	local screen = button and button.Screen
	local aspect = button and button.TraitData and button.TraitData.Name
	if not screen or not aspect then
		return returnValue
	end

	local componentId = screen.Components
		and screen.Components.RestoreLoadoutButton
		and screen.Components.RestoreLoadoutButton.Id
	if not componentId then
		modutil.mod.Print("Can't access component ID for Restore Loadout button")
		return returnValue
	end

	if IsLoadoutSaved(aspect) then
		game.SetAlpha({ Id = componentId, Fraction = 1, Duration = 0.1 })
		game.UseableOn({ Id = componentId })
	else
		game.SetAlpha({ Id = componentId, Fraction = 0, Duration = 0.0 })
		game.UseableOff({ Id = componentId })
	end

	CallCurrentCategoryStartFunction(screen, screen.ClipboardText)

	return returnValue
end)

modutil.mod.Path.Wrap("MouseOffWeaponUpgrade", function(base, button)
	local returnValue = base(button)

	local screen = button.Screen
	if not screen then
		return returnValue
	end

	local componentId = screen.Components
		and screen.Components.RestoreLoadoutButton
		and screen.Components.RestoreLoadoutButton.Id
	if not componentId then
		modutil.mod.Print("Can't access component ID for Restore Loadout button")
		return returnValue
	end

	game.SetAlpha({ Id = componentId, Fraction = 0, Duration = 0.1 })
	game.UseableOff({ Id = componentId })

	CallCurrentCategoryEndFunction(screen, screen.ClipboardText)

	return returnValue
end)

modutil.mod.Path.Override("SelectWeaponUpgrade", function(screen, weaponName, traitData)
	if GameState.LastWeaponUpgradeName[weaponName] == traitData.Name then
		-- Already equipped
		return
	end

	if GetCurrentCategory() == "DefaultModel" then
		local weaponUpgradeSwitchFx = CreateScreenObstacle({
			Name = "BlankObstacle",
			X = 200 + ScreenCenterNativeOffsetX,
			Y = 360 + ScreenCenterNativeOffsetY,
			Group = "Combat_Menu_Overlay_Additive",
		})
		SetAnimation({ Name = "WeaponUpgradeSwitchFx", DestinationId = weaponUpgradeSwitchFx })
		DestroyOnDelay({ Id = weaponUpgradeSwitchFx, 3 })
	end

	local prevTraitData = GetHeroTrait(GameState.LastWeaponUpgradeName[weaponName])
	if prevTraitData and prevTraitData.LinkedSpell then
		UnequipLinkedSpell(prevTraitData)
		local traitName = SpellData[prevTraitData.LinkedSpell].TraitName
		local spellTrait = GetHeroTrait(traitName)
		RemoveTrait(CurrentRun.Hero, spellTrait.Name)
	end
	PlaySound({ Name = traitData.EquipSound or "/Leftovers/SFX/PerfectTiming" })

	if GameState.LastWeaponUpgradeName[weaponName] ~= nil then
		-- Unequip previous trait
		if prevTraitData.OnUnequipFunctionName then
			thread(CallFunctionName, prevTraitData.OnUnequipFunctionName)
		end
		if prevTraitData.StopVfxOnUnequip then
			StopAnimation({ Name = prevTraitData.StopVfxOnUnequip, DestinationId = CurrentRun.Hero.ObjectId })
		end
		RemoveTrait(CurrentRun.Hero, GameState.LastWeaponUpgradeName[weaponName])
	end

	UnequipWeapon({ DestinationId = CurrentRun.Hero.ObjectId, Name = weaponName, UnloadPackages = false })
	MapState.EquippedWeapons[weaponName] = nil

	local weaponSetNames = WeaponSets.HeroWeaponSets[weaponName]
	if weaponSetNames ~= nil then
		for k, linkedWeaponName in ipairs(weaponSetNames) do
			UnequipWeapon({ DestinationId = CurrentRun.Hero.ObjectId, Name = linkedWeaponName, UnloadPackages = false })
			MapState.EquippedWeapons[linkedWeaponName] = nil
		end
	end

	EquipWeapon({ DestinationId = CurrentRun.Hero.ObjectId, Name = weaponName })
	MapState.EquippedWeapons[weaponName] = true
	if weaponSetNames ~= nil then
		for k, linkedWeaponName in ipairs(weaponSetNames) do
			EquipWeapon({ DestinationId = CurrentRun.Hero.ObjectId, Name = linkedWeaponName })
			MapState.EquippedWeapons[linkedWeaponName] = true
		end
	end
	-- Weapon upgrade code blows away all property changes related to the weapon
	OrderAndApplyPropertyChanges(ToLookup(weaponSetNames))

	GameState.LastWeaponUpgradeName[weaponName] = traitData.Name

	-- Equip new trait
	EquipWeaponUpgrade(existingHero, { SkipTraitHighlight = true, SkipUIUpdate = true })
	thread(PlayVoiceLines, GlobalVoiceLines.SwitchedWeaponUpgradeVoiceLines, true)

	screen.AspectChanged = true
end)

modutil.mod.Path.Wrap("OpenWeaponUpgradeScreen", function(base, ...)
	AspectLoadout.CurrentIndex = 1
	return base(...)
end)
