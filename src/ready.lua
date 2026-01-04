---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- This is called anytime a weapon is interacted with in pre-run hub room
modutil.mod.Path.Wrap("UseWeaponKit", function(base, weaponKit, args, user)
	modutil.mod.Print("UseWeaponKit: " .. weaponKit.Name)
	return base(weaponKit, args, user)
end)

-- This is called by UseWeaponKit when we are changing the weapon kit (not aspect)
modutil.mod.Path.Wrap("PickupWeaponKit", function(base, weaponKit, args)
	modutil.mod.Print("PickupWeaponKit: " .. weaponKit.Name)
	return base(weaponKit, args)
end)

-- This is called inside weapon aspect page when any aspect gets selected
modutil.mod.Path.Wrap("HandleWeaponUpgradeSelection", function(base, screen, button)
	modutil.mod.Print("HandleWeaponUpgradeSelection, weapon: " .. button.WeaponName .. " trait: " .. button.TraitData.Name)
	return base(screen, button)
end)
