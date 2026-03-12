class_name LightData extends Resource

@export var intensity : float = 0.6
@export var color : Color = Color.WHITE
@export var radius : float = 0.2
@export var flicker_strength : float = 0.5
@export var flicker_speed : float = 0.5

func mix(other: LightData, curve: Curve, step: float) -> LightData:
	var t := curve.sample(1.0 - step)
	t = clampf(t, 0.0, 1.0)
	var current_light := LightData.new()
	current_light.intensity = lerp(intensity, other.intensity, t)
	current_light.radius = lerp(radius, other.radius, t)
	current_light.color = color.lerp(other.color, t)
	current_light.flicker_strength = lerpf(flicker_strength, other.flicker_strength, t)
	current_light.flicker_speed = lerpf(flicker_speed, other.flicker_speed, t)

	return current_light
