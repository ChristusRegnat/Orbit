class_name Globals

extends Node

signal turret_count_changed(new_value: int)
signal ship_count_changed(new_value: int)


# Declare Global Variables
static var WinCondition: bool = true
var TurretCount: int = 3
var ShipCount: int = 3
var HP: int = 15

func increment_turret_count() -> void:
	TurretCount += 1
	var _turret_count: int = TurretCount
	turret_count_changed.emit(_turret_count)

func increment_ship_count() -> void:
	ShipCount += 1
	
	
