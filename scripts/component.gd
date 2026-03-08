class_name Component extends Node

var _entity : Entity
var entity : Entity:
	get:
		return _entity

func setup(owner_entity : Entity) -> void:
	assert(owner_entity != null, "Component setup requires a valid Entity")
	assert(_entity == null, "Entity already asignated to this component")
	_entity = owner_entity
