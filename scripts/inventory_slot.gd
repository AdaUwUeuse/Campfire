class_name InventorySlot extends Resource

@export var item : ItemData = null
@export_range(0.0, 999.0, 1.0) var item_count : int = 0

func is_empty() -> bool:
	return not item or item_count == 0
