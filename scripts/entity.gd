class_name Entity extends Node2D

var _components : Dictionary[Script, Component] = {}

func _cache_components() -> void:
	_clear_cache()
	for child in get_children():
		if child is Component:
			if _components.has(child.get_script()):
				push_warning("Component \"%s\" already registered, ignored" % child.get_class())
				continue
			_components.set(child.get_script(), child)

func _clear_cache() -> void:
	_components.clear()

func has_component(type : Script) -> bool:
	if not type:
		return false
	if _components.has(type):
		return true
	for component in _components.values():
		if is_instance_of(component, type):
			return true
	return false

func get_component(type : Script) -> Component:
	var base_component : Component = _components.get(type)
	if base_component:
		return base_component
	for component in _components.values():
		if is_instance_of(component, type):
			return component
	return null

func _on_child_entered(child : Node) -> void:
	if child is Component:
		var script : Script = child.get_script()
		if _components.has(script):
			push_warning("Component \"%s\" already in entity tree, ignored" % child.get_class())
			return
		_components.set(script, child)

func _on_child_exiting(child : Node) -> void:
	if child is Component:
		_components.erase(child.get_script())

func _ready() -> void:
	_cache_components()
	child_entered_tree.connect(_on_child_entered)
	child_exiting_tree.connect(_on_child_exiting)

func _exit_tree() -> void:
	if child_entered_tree.is_connected(_on_child_entered):
		child_entered_tree.disconnect(_on_child_entered)
	if child_exiting_tree.is_connected(_on_child_exiting):
		child_exiting_tree.disconnect(_on_child_exiting)
