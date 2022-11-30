extends Spatial


var run_speed : float = 8.0
var jump_length : float = 5.5
var jump_height : float = 8

var initial_road_count :int = 5
var road_scenes = [
	load("res://Scenes/Road1.tscn"),
	load("res://Scenes/Road2.tscn"),
	load("res://Scenes/Road3.tscn"),
]

onready var player = $Player
onready var camera_pivot = $CameraPivot
# Called when the node enters the scene tree for the first time.
func _ready():
	player.setup_jump(jump_length, jump_height, run_speed)
	randomize()
	
	for i in range(initial_road_count):
		var road = make_random_road()
		road.translation.z = -(i+1) * RoadBase.LENGTH
		add_child(road)

func _physics_process(delta):
	if player.translation.z < -RoadBase.LENGTH:
		player.translation.z += RoadBase.LENGTH
		
		for child in get_children():
			var road = child as RoadBase
			if road:
				road.translation.z += RoadBase.LENGTH
				if road.translation.z > RoadBase.LENGTH:
					road.queue_free()
		var new_road := make_random_road()
		new_road.translation.z = initial_road_count * -RoadBase.LENGTH
		add_child(new_road)
	
	camera_pivot.translation = player.translation
	
func make_random_road() -> RoadBase:
	var road_scene = road_scenes[randi() % road_scenes.size()]
	var road = road_scene.instance()
	return road
