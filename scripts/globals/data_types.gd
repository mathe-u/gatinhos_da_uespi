class_name DataTypes

enum Tools {
	None,
	AxeWood,
	GunBlaster,
	TillGround,
	WaterCrops,
	PlantCorn,
	PlantTomato,
	Torch,
}

enum GrowthStates {
	Seed,
	Germination,
	Vegetative,
	Reproduction,
	Maturity,
	Harvesting
}

enum ItemType {
	Consumable,
	MaterialItem,
}

enum Effect {
	None,
	IcreaseHealth,
	Healing,
	HealthRegen,
	IncreaseInventorySlots,
	Venon,
	SpeedUp,
	SpeedDown,
	RestoreEnergy,
}

enum EventUnlock {
	None,
	BrokenBridge,
	ShipFloor,
	ShipEngine,
	ShipHull,
}
