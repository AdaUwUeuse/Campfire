class_name LightShader extends ColorRect

const MAX_LIGHTS : int = 16

var light_count : int = 0

#basics property
var light_positions : Array[Vector2] = []
var light_radius : Array[float] = []
var light_colors : Array[Color] = []
var light_intensities : Array[float] = []

#flickering
var flicker_strength : Array[float];
var flicker_speed : Array[float];
var flicker_seed : Array[float];

var light_map : Dictionary[Node2D, int] = {}

func _clear_light() -> void:
	light_count = 0
	light_positions.clear()
	light_radius.clear()
	light_colors.clear()
	light_intensities.clear()
	flicker_strength.clear()
	flicker_speed.clear()
	flicker_seed.clear()
	
	light_map.clear()

func _compute_screen_position(world_pos: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	var viewport_size := get_viewport_rect().size
	return (world_pos - cam.global_position) / viewport_size + Vector2(0.5, 0.5)
	
func _compute_screen_radius(global_radius : float) -> float:
	var screen_radius : float = global_radius / get_viewport_rect().size.y
	return screen_radius

signal shader_update_required

func update_light(light : Node2D, update_shader : bool = false) -> void:
	if not light_map.has(light):
		push_warning("Unknow light in node: %s, ignored" % light.name)
		return
	var light_data : LightData = light.get_light_data()
	if not light_data:
		push_warning("Missing LightData in node: %s, ignored" % light.name)
		return
	var index : int = light_map[light]
	var world_position : Vector2 = light.global_position
	var screen_position : Vector2 = _compute_screen_position(world_position)
	light_positions[index] = screen_position
	light_radius[index] = _compute_screen_radius(light_data.radius)
	light_colors[index] = light_data.color
	light_intensities[index] = light_data.intensity
	flicker_strength[index] = light_data.flicker_strength
	flicker_speed[index] = light_data.flicker_speed
	flicker_seed[index] = randf() * 100.0
	if update_shader:
		shader_update_required.emit()
	
func update_all_lights() -> void:
	_clear_light()
	var nodes := get_tree().get_nodes_in_group("Light")
	for n in nodes:
		if light_count >= MAX_LIGHTS:
			break
		if n is Node2D and n.has_method("get_light_data"):
			var n2d : Node2D = n as Node2D
			light_map[n2d] = light_count
			light_positions.append(Vector2.ZERO)
			light_radius.append(0.0)
			light_colors.append(Color.WHITE)
			light_intensities.append(0.0)
			flicker_strength.append(0.0)
			flicker_speed.append(0.0)
			flicker_seed.append(0.0)
			update_light(n2d)
			light_count += 1
	shader_update_required.emit()

func _ready() -> void:
	visible = true
	shader_update_required.connect(_update_shader)
	update_all_lights()

func _physics_process(_delta: float) -> void:
	update_all_lights()
	_update_shader()

func _update_shader() -> void:
	var mat : ShaderMaterial = material as ShaderMaterial
	
	if not mat:
		push_warning("Invalid shader, can't update lights")
		return
	mat.set_shader_parameter("light_count", light_count)
	mat.set_shader_parameter("positions", light_positions)
	mat.set_shader_parameter("radius", light_radius)
	mat.set_shader_parameter("intensities", light_intensities)
	mat.set_shader_parameter("colors", light_colors)
	mat.set_shader_parameter("flicker_strength", flicker_strength)
	mat.set_shader_parameter("flicker_speed", flicker_speed)
	mat.set_shader_parameter("flicker_seed", flicker_seed)
