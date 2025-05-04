extends Node

const DEFAULT_SERVER_IP: String = "127.0.0.1"
const PORT: int = 6007
const MAX_CONNECTIONS: int = 20
const SERVER_ID: int = 1

var peer: ENetMultiplayerPeer

signal connection_established
signal connection_failed
signal player_list_updated

func _ready() -> void:
	multiplayer.peer_connected.connect(on_player_connected)
	multiplayer.peer_disconnected.connect(on_player_disconnected)
	multiplayer.connected_to_server.connect(on_connection_ok)
	multiplayer.connection_failed.connect(on_connection_failed)
	multiplayer.server_disconnected.connect(on_server_disconnected)


func join_server(server_ip: String, new_player_name: String) -> void:
	GameManager.player_name = new_player_name
	if server_ip.is_empty():
		server_ip = DEFAULT_SERVER_IP

	peer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(server_ip, PORT)

	if error:
		print(error)
		on_connection_failed()
		connection_failed.emit()
		return

	multiplayer.multiplayer_peer = peer
	connection_established.emit()
	print("join on (" + server_ip + ")")


func create_server(new_player_name: String) -> void:
	GameManager.player_name = new_player_name
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	
	if error:
		print("cannot create host: ", error)
		return 
	
	multiplayer.set_multiplayer_peer(peer)
	SaveGameManager.allow_save_game = true
	print("server game created")


@rpc("any_peer")
func register_player(new_player_name: String) -> void:
	var id: int = multiplayer.get_remote_sender_id()
	GameManager.players[id] = {"name": new_player_name, "color": 0}
	player_list_updated.emit()


#@rpc("any_peer")
#func remove_player(id: int) -> void:
	#GameManager.players.erase(id)
	#player_list_updated.emit()
	#print("remove player ", id)


@rpc("call_local")
func load_game_scene() -> void:
	var current_scene = get_tree().root.get_node("Lobby")
	
	#var error: Error = get_tree().change_scene_to_file("res://scenes/test/test_scene_multiplayer.tscn")
	
	var world: Node = load("res://scenes/test/test_scene_multiplayer.tscn").instantiate()
	if world != null:
		get_tree().root.add_child(world)
	
	if current_scene:
		current_scene.queue_free()
	
	get_tree().current_scene = world


func disconnect_peer():
	if multiplayer.multiplayer_peer:
		#var id: int = multiplayer.get_unique_id()
		#print("----que peer chamou? ", id)
		#remove_player.rpc_id(id)
		#if multiplayer.is_server():
			#print("quem chamou foi o server")
		#else:
			#print("quem chamou foi o cliente")
		
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		print("ServerManager: Peer disconnected.")


func on_player_connected(id: int) -> void:
	register_player.rpc_id(id, GameManager.player_name)
	print("ServerManager (Server): Player connected with ID: ", id)


func on_player_disconnected(id: int) -> void:
	GameManager.players.erase(id)
	player_list_updated.emit()
	print("ServerManager (Server): Player disconnected with ID: ", id)


func on_connection_ok() -> void:
	print("ServerManager (Client ", multiplayer.get_unique_id(), "): Connection to server successful!")
	connection_established.emit()


func on_connection_failed() -> void:
	print("ServerManager (Client): Connection failed.")
	multiplayer.multiplayer_peer = null
	connection_failed.emit()


func on_server_disconnected():
	print("ServerManager (Client): Server disconected")
	disconnect_peer()
	get_tree().change_scene_to_file("res://scenes/ui/game_menu_screen.tscn")
