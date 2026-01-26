local function MakeLoadout()
	return {
		Saved = false,
		Boons = "",
		Keepsakes = "",
		Familiar = "",
		Arcanas = "",
		FearOaths = "",
	}
end

local function MakeLoadoutDescription()
	return {
		Saved = "Set to true if a loadout was saved for this aspect",
		Boons = "List of boons to pin, separated by ','",
		Keepsakes = "List of keepsakes to set as favorite, separated by ','",
		Familiar = "Familiar to use",
		Arcanas = "List of arcanas to use, separated by ','",
		FearOaths = "List of fear oaths use, separated by ',' (not implemented yet!)",
	}
end

local config = {
	enabled = true,
	AutoRestoreLoadoutEnabled = false,
	Loadout = {
		BaseStaffAspect = MakeLoadout(),
		StaffClearCastAspect = MakeLoadout(),
		StaffSelfHitAspect = MakeLoadout(),
		StaffRaiseDeadAspect = MakeLoadout(),
		DaggerBackstabAspect = MakeLoadout(),
		DaggerBlockAspect = MakeLoadout(),
		DaggerHomingThrowAspect = MakeLoadout(),
		DaggerTripleAspect = MakeLoadout(),
		TorchSpecialDurationAspect = MakeLoadout(),
		TorchDetonateAspect = MakeLoadout(),
		TorchSprintRecallAspect = MakeLoadout(),
		TorchAutofireAspect = MakeLoadout(),
		AxeRecoveryAspect = MakeLoadout(),
		AxeArmCastAspect = MakeLoadout(),
		AxePerfectCriticalAspect = MakeLoadout(),
		AxeRallyAspect = MakeLoadout(),
		LobAmmoBoostAspect = MakeLoadout(),
		LobCloseAttackAspect = MakeLoadout(),
		LobImpulseAspect = MakeLoadout(),
		LobGunAspect = MakeLoadout(),
		BaseSuitAspect = MakeLoadout(),
		SuitHexAspect = MakeLoadout(),
		SuitMarkCritAspect = MakeLoadout(),
		SuitComboAspect = MakeLoadout(),
	},
}

local configDesc = {
	enabled = "Enable the mod",
	AutoRestoreLoadoutEnabled = "Enable restoring automatically the loadout when picking the weapon (not implemented yet!)",
	Loadout = {
		BaseStaffAspect = MakeLoadoutDescription(),
		StaffClearCastAspect = MakeLoadoutDescription(),
		StaffSelfHitAspect = MakeLoadoutDescription(),
		StaffRaiseDeadAspect = MakeLoadoutDescription(),
		DaggerBackstabAspect = MakeLoadoutDescription(),
		DaggerBlockAspect = MakeLoadoutDescription(),
		DaggerHomingThrowAspect = MakeLoadoutDescription(),
		DaggerTripleAspect = MakeLoadoutDescription(),
		TorchSpecialDurationAspect = MakeLoadoutDescription(),
		TorchDetonateAspect = MakeLoadoutDescription(),
		TorchSprintRecallAspect = MakeLoadoutDescription(),
		TorchAutofireAspect = MakeLoadoutDescription(),
		AxeRecoveryAspect = MakeLoadoutDescription(),
		AxeArmCastAspect = MakeLoadoutDescription(),
		AxePerfectCriticalAspect = MakeLoadoutDescription(),
		AxeRallyAspect = MakeLoadoutDescription(),
		LobAmmoBoostAspect = MakeLoadoutDescription(),
		LobCloseAttackAspect = MakeLoadoutDescription(),
		LobImpulseAspect = MakeLoadoutDescription(),
		LobGunAspect = MakeLoadoutDescription(),
		BaseSuitAspect = MakeLoadoutDescription(),
		SuitHexAspect = MakeLoadoutDescription(),
		SuitMarkCritAspect = MakeLoadoutDescription(),
		SuitComboAspect = MakeLoadoutDescription(),
	},
}

return config, configDesc
