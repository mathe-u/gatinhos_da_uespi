extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var minor_label: Label = $IntroContainer/Mentions/MinorLabel
@onready var main_label: Label = $IntroContainer/Mentions/MainLabel
@onready var texture_rect: TextureRect = $IntroContainer/Mentions/MarginContainer/TextureRect

var new_theme: Theme = Theme.new()
var i: FontFile
var font: Font = load("res://assets/ui/fonts/pixelFont-7-8x14-sproutLands.ttf")

func _ready() -> void:
	minor_label.add_theme_font_override("font", font)
	main_label.add_theme_font_override("font", font)
	minor_label.hide()
	main_label.hide()
	texture_rect.hide()
	
	init_presentation()

func init_presentation() -> void:
	main_label.show()
	main_label.add_theme_font_size_override("font_size", 36)
	main_label.text = "Comerato games presents"
	animation_player.play("fade_in")
	
	get_tree().create_timer(3).timeout.connect(fade_out_presents)


func fade_out_presents() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(3).timeout.connect(game_title)


func game_title() -> void:
	main_label.add_theme_font_size_override("font_size", 54)
	main_label.text = "GamotoLands"
	animation_player.play("fade_in")
	
	get_tree().create_timer(3).timeout.connect(game_title_fade_out)


func game_title_fade_out() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(3).timeout.connect(game_by)


func game_by() -> void:
	minor_label.add_theme_font_size_override("font_size", 18)
	minor_label.text = "A game by"
	minor_label.show()
	
	main_label.add_theme_font_size_override("font_size", 36)
	main_label.text = "comerato games"
	
	animation_player.play("fade_in")
	
	get_tree().create_timer(3).timeout.connect(game_by_fade_out)


func game_by_fade_out() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(3).timeout.connect(game_power_by)


func game_power_by() -> void:
	texture_rect.show()
	
	minor_label.text = "power by"
	main_label.text = "godot engine"
	
	animation_player.play("fade_in")
	
	get_tree().create_timer(3).timeout.connect(game_power_by_fade_out)


func game_power_by_fade_out() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(3).timeout.connect(start_menu_scene)

func start_menu_scene() -> void:
	SceneManager.set_next_scene("res://scenes/ui/game_menu_screen.tscn")
	get_tree().change_scene_to_file("res://scenes/ui/loading_screen.tscn")
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		start_menu_scene()
