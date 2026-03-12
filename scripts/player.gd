class_name Player extends CharacterBody2D

@export var base_speed : float = 240.0
@export var run_speed_coeficient : float = 1.7
@export var base_acceleration : float = 950.0
@export var run_acceleration_coeficient : float = 1.4
@export var slowdown_acceleration : float = 1800.0

@export var inventory : Inventory = null

@onready var pickup_collector_area : Area2D = %PickupCollectorArea

func _try_collect_item_pickup(pickup : ItemPickup) -> void:
	if not inventory:
		return
	var item_data : ItemData = pickup.look_item()
	if inventory.has_space_for(item_data, 1):
		item_data = pickup.collect()
		inventory.insert_item(item_data, 1)
		pickup.destruct()

func _on_area_entered(area: Area2D) -> void:
	if area is ItemPickup:
		_try_collect_item_pickup(area as ItemPickup)

signal inventory_updated

func _ready() -> void:
	pickup_collector_area.area_entered.connect(_on_area_entered)
	if inventory:
		inventory.inventory_updated.connect(inventory_updated.emit)

func get_input_direction() -> Vector2:
	return Input.get_vector(
			"player_move_left",
			"player_move_right",
			"player_move_up",
			"player_move_down"
		)

func _get_speed() -> float:
	if Input.is_action_pressed("player_intent_sprint"):
		return base_speed * run_speed_coeficient
	return base_speed

func _get_acceleration() -> float:
	if Input.is_action_pressed("player_intent_sprint"):
		return base_acceleration * run_acceleration_coeficient
	return base_acceleration

func _physics_process(delta: float) -> void:
	var target_velocity : Vector2 = Vector2.ZERO
	var direction : Vector2 = get_input_direction()
	if direction:
		target_velocity = direction * _get_speed()
		velocity = velocity.move_toward(target_velocity, delta * _get_acceleration())
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * slowdown_acceleration)
	move_and_slide()
