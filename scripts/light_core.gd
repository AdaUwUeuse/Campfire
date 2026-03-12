class_name LightCore extends Node2D

@export var min_fuel_light : LightData
@export var max_fuel_light : LightData

@export var extinction_curve : Curve

@onready var fuel_label : Label = %FuelLabel
@onready var flame_sprite : AnimatedSprite2D = %FlameAnimatedSprite

var max_fuel : float = 600.0
var current_fuel : float = 600.0
var fuel_comsuption : float = 10.0 

func get_light_data() -> LightData:
	var t := clampf(current_fuel / max_fuel, 0.0, 1.0)
	return max_fuel_light.mix(min_fuel_light, extinction_curve, t)

func _update_fuel_label() -> void:
	fuel_label.text = String("Fuel: %d%%" % int((current_fuel / max_fuel) * 100.0))

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	current_fuel = clampf(current_fuel - delta * fuel_comsuption, 0.0, max_fuel)
	_update_fuel_label()
