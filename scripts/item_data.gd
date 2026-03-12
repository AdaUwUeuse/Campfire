class_name ItemData extends Resource

const MISSING_WORLD_TEXTURE : Texture2D = preload("res://assets/textures/item_missing.svg")
const MISSING_INVENTORY_TEXTURE : Texture2D = preload("res://assets/textures/item_missing.svg")
const DEFAULT_DISPLAY_NAME : StringName = &"Unnamed item"
const DEFAULT_STACK_SIZE : int = 1

var _world_texture : Texture2D = null
@export var world_texture : Texture2D = null:
	get():
		if not _world_texture:
			return MISSING_WORLD_TEXTURE
		return _world_texture
	set(value):
		_world_texture = value 

var _inventory_texture : Texture2D = null
@export var inventory_texture : Texture2D = null:
	get():
		if not _inventory_texture:
			return MISSING_INVENTORY_TEXTURE
		return _inventory_texture
	set(value):
		_inventory_texture = value

@export var display_name : StringName = DEFAULT_DISPLAY_NAME
@export var stack_size : int = DEFAULT_STACK_SIZE

@export var collect_sfx : AudioStream = null
