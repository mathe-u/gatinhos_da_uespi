extends Control

@onready var day_label: Label = $DayPanel/MarginContainer/DayLabel
@onready var time_label: Label = $TimePanel/MarginContainer/TimeLabel
@onready var click_button: AudioStreamPlayer2D = $ClickButton

@export var normal_speed: int = 5
@export var fast_speed: int = 100
@export var cheetah_speed: int = 200

func _ready() -> void:
	DayNightCycleManager.time_tick.connect(on_time_tick)
	
func on_time_tick(day: int, hour: int, minute: int) -> void:
	day_label.text = "Day " + str(day)
	time_label.text = "%02d:%02d" % [hour, minute]
	
	

func _on_normal_speed_button_pressed() -> void:
	DayNightCycleManager.game_speed = normal_speed


func _on_fast_speed_button_pressed() -> void:
	DayNightCycleManager.game_speed = fast_speed


func _on_cheetah_speed_button_pressed() -> void:
	DayNightCycleManager.game_speed = cheetah_speed


func _on_inventory_button_pressed() -> void:
	click_button.play(0.60)
	GameManager.open_close_inventory()


func _on_settings_button_pressed() -> void:
	click_button.play(0.60)
	var settings_panel_scene: PackedScene = load("res://scenes/ui/settings_panel.tscn")
	var settings_panel_instance: PanelContainer = settings_panel_scene.instantiate()
	var game_screen: MarginContainer = get_tree().root.get_node("MainScene/GameScreen/MarginContainer")
	
	game_screen.add_child(settings_panel_instance)
	
