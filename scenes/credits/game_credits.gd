extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main_label: Label = $PanelContainer/VBoxContainer/MainLabel
@onready var minor_label: Label = $PanelContainer/VBoxContainer/MinorLabel

var new_theme: Theme = Theme.new()
var i: FontFile
var font: Font = load("res://assets/ui/fonts/zx_palm_variation.tres")

func _ready() -> void:
	minor_label.add_theme_font_override("font", font)
	main_label.add_theme_font_override("font", font)
	minor_label.hide()
	main_label.hide()
	
	init_credits()


func init_credits() -> void:
	main_label.show()
	main_label.add_theme_font_size_override("font_size", 36)
	main_label.text = "Creditos:"
	
	minor_label.add_theme_font_size_override("font_size", 18)
	minor_label.text = "matheus silva\nAntonio Guilherme\nmilena andrade\nJoão pedro"
	minor_label.show()
	
	animation_player.play("fade_in")
	
	get_tree().create_timer(1.5).timeout.connect(fade_out_init)


func fade_out_init() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(1.5).timeout.connect(thanks)


func thanks() -> void:
	main_label.text = "Fim"
	minor_label.text = "obrigado por jogar"
	get_tree().create_timer(1.5).timeout.connect(fade_out_thanks)


func fade_out_thanks() -> void:
	animation_player.play("fade_out")
	get_tree().create_timer(1.5).timeout.connect(start_menu_scene)


func start_menu_scene() -> void:
	SceneManager.set_next_scene("res://scenes/ui/game_menu_screen.tscn")
	get_tree().change_scene_to_file("res://scenes/ui/loading_screen.tscn")
