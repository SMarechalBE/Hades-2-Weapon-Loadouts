---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

local WeaponUpgradeScreenComponents = {

	ActionBar = {
		ChildrenOrder = {
			"CloseButton",
			"SelectButton",
			"EmptyButton",
			"RestoreLoadoutButton",
			"SaveLoadoutButton",
			-- "LoadoutLabel",
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
			-- "NextTraitShow",
			"PreviousTraitShow",
		},

		Children = {
			-- NextTraitShow = {
			-- 	Graphic = "ContextualActionButton",
			-- 	Data = {
			-- 		OnPressedFunctionName = _PLUGIN.guid .. "." .. "NextTraitShowButton",
			-- 		ControlHotkeys = { "NextLayout" },
			-- 	},
			-- 	Text = "{NL} NEXT SET",
			-- 	TextArgs = UIData.ContextualButtonFormatLeft,
			-- },

			PreviousTraitShow = {
				Graphic = "ContextualActionButton",
				Data = {
					OnPressedFunctionName = _PLUGIN.guid .. "." .. "PreviousTraitShowButton",
					ControlHotkeys = { "PrevLayout" },
				},
				Text = "{PL} DISPLAY TRAITS",
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

function mod.WeaponLoadoutScreenCloseTraitTray(screen, args)
	screen = args.Screen or screen
	local selectedIndex = args.Index or 1

	local WeaponLoadoutScreenComponents = screen.Components

	for index = 1, 4 do
		if WeaponLoadoutScreenComponents["PurchaseButton" .. index] then
			game.SetAlpha({
				Id = WeaponLoadoutScreenComponents["PurchaseButton" .. index].Id,
				Fraction = 1.0,
				Duration = 0.2,
			})
		end
	end

	game.TeleportCursor({
		DestinationId = WeaponLoadoutScreenComponents["PurchaseButton" .. selectedIndex].Id,
		ForceUseCheck = true,
	})

	if WeaponLoadoutScreenComponents.SelectButton then
		game.SetAlpha({ Id = WeaponLoadoutScreenComponents.SelectButton.Id, Fraction = 1.0, Duration = 0.2 })
	end

	if WeaponLoadoutScreenComponents.CloseButton then
		game.SetAlpha({ Id = WeaponLoadoutScreenComponents.CloseButton.Id, Fraction = 1.0, Duration = 0.2 })
	end

	if WeaponLoadoutScreenComponents.SaveLoadoutButton then
		game.SetAlpha({ Id = WeaponLoadoutScreenComponents.SaveLoadoutButton.Id, Fraction = 1.0, Duration = 0.2 })
	end

	if WeaponLoadoutScreenComponents.RestoreLoadoutButton then
		game.SetAlpha({ Id = WeaponLoadoutScreenComponents.RestoreLoadoutButton.Id, Fraction = 1.0, Duration = 0.2 })
	end

	-- if WeaponLoadoutScreenComponents.NextTraitShow then
	-- 	game.SetAlpha({ Id = WeaponLoadoutScreenComponents.NextTraitShow.Id, Fraction = 1.0, Duration = 0.2 })
	-- end

	if WeaponLoadoutScreenComponents.PreviousTraitShow then
		game.SetAlpha({ Id = WeaponLoadoutScreenComponents.PreviousTraitShow.Id, Fraction = 1.0, Duration = 0.2 })
	end

	game.HideCombatUI(screen.Name)
end

--
-- Leaving this here for now as I feel it could be optimized
--
-- function mod.NextTraitShowButton(screen, button)
-- 	modutil.mod.Print("Cycle to next TraitTray screen")
-- end

function mod.PreviousTraitShowButton(screen, button)
	for index = 1, 4 do
		if screen.Components["PurchaseButton" .. index] then
			game.SetAlpha({ Id = screen.Components["PurchaseButton" .. index].Id, Fraction = 0.0, Duration = 0.2 })
		end
	end

	if screen.Components.SelectButton then
		game.SetAlpha({ Id = screen.Components.SelectButton.Id, Fraction = 0.0, Duration = 0.2 })
	end

	if screen.Components.CloseButton then
		game.SetAlpha({ Id = screen.Components.CloseButton.Id, Fraction = 0.0, Duration = 0.2 })
	end

	if screen.Components.SaveLoadoutButton then
		game.SetAlpha({ Id = screen.Components.SaveLoadoutButton.Id, Fraction = 0.0, Duration = 0.2 })
	end

	if screen.Components.RestoreLoadoutButton then
		game.SetAlpha({ Id = screen.Components.RestoreLoadoutButton.Id, Fraction = 0.0, Duration = 0.2 })
	end

	-- if screen.Components.NextTraitShow then
	-- 	game.SetAlpha({ Id = screen.Components.NextTraitShow.Id, Fraction = 0.0, Duration = 0.2 })
	-- end

	if screen.Components.PreviousTraitShow then
		game.SetAlpha({ Id = screen.Components.PreviousTraitShow.Id, Fraction = 0.0, Duration = 0.2 })
	end

	game.ShowCombatUI(screen.Name)

	game.ShowTraitTrayScreen({
		CloseFunctionName = _PLUGIN.guid .. "." .. "WeaponLoadoutScreenCloseTraitTray",
		CloseFunctionArgs = { Screen = screen, Index = 2 },
		HideInfoButton = true,
	})
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

	return returnValue
end)

modutil.mod.Path.Wrap("TraitTrayScreenClose", function(base, screen, button, args)
	if screen and screen.CloseFunctionName == _PLUGIN.guid .. "." .. "WeaponLoadoutScreenCloseTraitTray" then
		args = { IgnoreHUDShow = true }
	end

	return base(screen, button, args)
end)
