class_name InventoryUI extends Control

@onready var _slot_container : GridContainer = %SlotContainer

@export var inventory : Inventory = null

func _update_slots() -> void:
	for child in _slot_container.get_children():
		child.queue_free()
	if not inventory:
		return
	for slot in inventory._slots:
		if not slot.is_empty():
			var texture_rect := TextureRect.new()
			texture_rect.texture = slot.item.inventory_texture
			_slot_container.add_child(texture_rect)
