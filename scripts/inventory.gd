class_name Inventory extends Resource

@export var _slot_count : int = 1
@export var _slots : Array[InventorySlot] = []

signal inventory_updated

func _ensure_slots() -> void:
	if _slots.size() >= _slot_count:
		return
	while _slots.size() < _slot_count:
		_slots.append(InventorySlot.new())

func has_space_for(item : ItemData, quantity : int) -> bool:
	return get_insertable_quantity(item) >= quantity

func get_insertable_quantity(item : ItemData) -> int:
	var available_quantity : int = 0
	_ensure_slots()
	for slot in _slots:
		if slot.is_empty():
			available_quantity += item.stack_size
		elif slot.item == item:
			available_quantity += (item.stack_size - slot.item_count)
	return available_quantity

##insert_item(item, quantity)
#insert quantity of item in inventory if it possible,
#return the item remaining quantity
func insert_item(item : ItemData, quantity : int) -> int:
	var remaining_quantity : int = quantity
	var insert_quantity : int = 0
	var item_inserted : bool = false
	_ensure_slots()
	for slot in _slots:
		if remaining_quantity == 0:
			break
		if slot.is_empty():
			insert_quantity = min(item.stack_size, remaining_quantity)
			slot.item = item
			slot.item_count = insert_quantity
			remaining_quantity -= insert_quantity
			item_inserted = true
		elif slot.item == item and slot.item_count < item.stack_size:
			insert_quantity = min(item.stack_size - slot.item_count, remaining_quantity)
			slot.item_count += insert_quantity
			remaining_quantity -= insert_quantity
			item_inserted = true
	if item_inserted:
		inventory_updated.emit()
	return remaining_quantity

func get_used_slot_count() -> int:
	var used_slot_count : int = 0
	for slot in _slots:
		if not slot.is_empty():
			used_slot_count += 1
	return used_slot_count
