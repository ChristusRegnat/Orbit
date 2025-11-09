class_name Globals

extends Node

signal turret_count_changed(new_value: int)
signal ship_count_changed(new_value: int)


# Declare Global Variables
static var WinCondition: bool = true
var TurretCount: int = 1
var ShipCount: int = 3
var HP: int = 10



func increment_turret_count() -> void:
	TurretCount += 1
	var _turret_count: int = TurretCount
	HP += 2
	turret_count_changed.emit(_turret_count)

func increment_ship_count() -> void:
	ShipCount += 1
	var _ship_count: int = ShipCount
	HP += 1
	ship_count_changed.emit(_ship_count)
	
