extends Node

const DEFAULT_SERVER_IP: String = "127.0.0.1"
const PORT: int = 24666
const MAX_CONNECTIONS: int = 20

#var server_ip: String

var peer: ENetMultiplayerPeer

func _ready() -> void:
	
	##if multiplayer.is_server():
		##once_per_client()
	#
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)
	multiplayer.connected_to_server.connect(on_connection_ok)
	multiplayer.connection_failed.connect(on_connection_failed)
	#multiplayer.server_disconnected.connect(_on_server_disconnected)
	pass

func join_server(server_ip: String) -> void:
	if server_ip.is_empty():
		server_ip = DEFAULT_SERVER_IP

	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(server_ip, PORT)

	if error:
			print(error)
			return

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	print("join on (" + server_ip + ")...")

func create_server() -> void:
	pass

func on_player_connected(id: int) -> void:
	print("player connected:", id)

func on_player_disconnected(id: int) -> void:
	GameManager.players.erase(id)
	##player_disconnected.emit(id)
	print("player disconnected:", id)
#
func on_connection_ok() -> void:
	print("connected to server")
	#send_player_information.rpc_id(SERVER_ID, player_name_line_edit.text, multiplayer.get_unique_id())
#
func on_connection_failed() -> void:
	print("could not connect to server")
	#multiplayer.multiplayer_peer = null
#
#@rpc("any_peer")
#func send_player_information(player_name: String, id: int) -> void:
	#if !GameManager.players.has(id):
		#GameManager.players[id] = {
			#"name": player_name,
			#"id": id,
			#"score": 0,
		#}
	#print("player name: ",GameManager.players[id]["name"])
	#if multiplayer.is_server():
		##print("is server:", multiplayer.get_unique_id())
		#for player in GameManager.players:
			#send_player_information.rpc(
				#GameManager.players[player].name,
				#player,
			#)
#
#@rpc("any_peer", "call_local")
#func start_game() -> void:
	#var game_scene = load("res://scenes/test/test_scene_multiplayer.tscn").instantiate()
	#get_tree().root.add_child(game_scene)
	##self.hide()
#
#
#func _on_host_button_down() -> void:
	#peer = ENetMultiplayerPeer.new()
	#var error = peer.create_server(port, 4)
	#
	#if error != OK:
		#print("cannot host:", error)
		#return
	#
	#peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	#multiplayer.set_multiplayer_peer(peer)
	#print("waiting for players...")
	#send_player_information(player_name_line_edit.text, multiplayer.get_unique_id())
#
#
#func _on_join_button_down() -> void:
	#if host_address_line_edit.text.is_empty():
		#print("entrando...")
		#peer = ENetMultiplayerPeer.new()
		
	#else:
		#print("endereco")
#
#
#func _on_start_button_down() -> void:
	#start_game.rpc()
	#
#
#func remove_multiplayer_peer():
	#multiplayer.multiplayer_peer = null
	#GameManager.players.clear()
#
#func _on_server_disconnected():
	#multiplayer.multiplayer_peer = null
	#GameManager.players.clear()
	##server_disconnected.emit()
#
#
#@rpc()
#func once_per_client()-> void:
	#print("I will be printed to the console once per each connected client.")
#
#func _on_some_input(): # Connected to some input.
	#transfer_some_input.rpc_id(1)
#
#@rpc("any_peer", "call_local", "reliable")
#func transfer_some_input() -> void:
	## The server knows who sent the input.
	#var sender_id: int = multiplayer.get_remote_sender_id()
	#print("sender id: ", sender_id)
	## Process the input and affect game logic.
#
#
#func _on_back_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")
