class_name Main extends Node2D

const PICKUP : PackedScene = preload("res://scenes/item_pickup.tscn")
const ITEM_WOOD : ItemData = preload("res://assets/resources/item/wood_log.tres")
const ITEM_ROCK : ItemData = preload("res://assets/resources/item/rock.tres")

#func _ready() -> void:
	#$CanvasLayer/InventoryUI.inventory = $Player.inventory
	#var timer := Timer.new()
	#timer.wait_time = 1.0
	#timer.autostart = true
	#timer.one_shot = false
	#timer.timeout.connect(func():
			#var new_pickup := PICKUP.instantiate() as ItemPickup
			#new_pickup._item_data = ITEM_WOOD if randi_range(0, 1) == 0 else ITEM_ROCK
			#new_pickup.global_position = Vector2(randf() * 1000.0, randf() * 600)
			#self.add_child(new_pickup))
	#self.add_child(timer)
