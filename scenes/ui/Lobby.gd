extends CanvasLayer

@onready var player_name_line_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer2/PlayerNameLineEdit
@onready var host_address_line_edit: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/HostAddressLineEdit
@onready var host_button: Button = $MarginContainer/VBoxContainer/HBoxContainer3/Host
@onready var start_button: Button = $MarginContainer/VBoxContainer/HBoxContainer3/Start
@onready var join_button: Button = $MarginContainer/VBoxContainer/HBoxContainer3/Join
@onready var h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer
@onready var item_list: ItemList = $MarginContainer/VBoxContainer/ItemList

var default_player_name: String = "Player_" + str(randi())

func _ready() -> void:
	start_button.disabled = true
	join_button.disabled = false
	host_address_line_edit.editable = true
	player_name_line_edit.editable = true
	host_address_line_edit.text = ServerManager.DEFAULT_SERVER_IP
	player_name_line_edit.text = default_player_name
	
	item_list.clear()
	
	ServerManager.connection_established.connect(_on_connection_established)
	ServerManager.connection_failed.connect(_on_connection_failed)
	ServerManager.player_list_updated.connect(refresh_lobby)


func _on_host_pressed() -> void:
	join_button.disabled = true
	start_button.disabled = false
	host_button.disabled = true
	
	var player_name: String = player_name_line_edit.text
	
	ServerManager.create_server(player_name)
	refresh_lobby()


func _on_join_pressed() -> void:
	join_button.disabled = true
	start_button.disabled = true
	host_button.disabled = true
	
	var player_name: String = player_name_line_edit.text
	var host_ip: String = host_address_line_edit.text.strip_edges()
	
	ServerManager.join_server(host_ip, player_name)


func _on_start_pressed() -> void:
	start_button.disabled = true
	GameManager.start_game()
	print("MultiplayerMenuScreen: Botão 'Start' pressionado.")


func _on_back_pressed() -> void:
	ServerManager.disconnect_peer()
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")


func _on_connection_established() -> void:
	start_button.disabled = false
	join_button.disabled = true
	host_address_line_edit.editable = false
	player_name_line_edit.editable = true
	player_name_line_edit.grab_focus()
	await get_tree().process_frame


func _on_connection_failed():
	start_button.disabled = true
	join_button.disabled = false
	host_button.disabled = false
	host_address_line_edit.editable = true
	player_name_line_edit.editable = true


func refresh_lobby() -> void:
	print("sinal para atualizar a lista recebido")
	#var players = ServerManager.get_player_list()
	var players = GameManager.players.values()
	players.sort()
	item_list.clear()
	item_list.add_item(GameManager.player_name + " (You)")
	for player in players:
		item_list.add_item(player)
	
	start_button.disabled = not multiplayer.is_server()
