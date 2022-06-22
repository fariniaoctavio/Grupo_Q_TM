extends Control

const DEFAULT_PORT = 8081

onready var ipHost = $IPHostInput
onready var hostearButton = $HostearButton
onready var unirseButton = $UnirseButton
onready var status_ok = $StatusOk
onready var status_fail = $StatusFail

var peer = null

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(_id):
	var escenaPrueba = load("res://TestMultiplayer.tscn").instance()

	escenaPrueba.connect("game_finished", self, "_end_game", [], CONNECT_DEFERRED)

	get_tree().get_root().add_child(escenaPrueba)
	hide()

func _player_disconnected(_id):
	if get_tree().is_network_server():
		_end_game("El Cliente se desconecto")
	else:
		_end_game("El Servidor se desconecto")

func _connected_ok():
	pass

func _connected_fail():
	get_tree().set_network_peer(null)
	hostearButton.set_disabled(false)
	unirseButton.set_disabled(false)
	
	_set_status("No se pudo conectar", false)

func _server_disconnected():
	_end_game("El Servidor se desconecto")

##### Funciones Para Inicializar El Juego ######
#De momento esta en desarrollo

func _end_game(errorMsg = ""):
	if has_node("/root/MultijugadorRootNode"):
		get_node("/root/MultijugadorRootNode").free()
		show()

	get_tree().set_network_peer(null) # Remove peer.
	hostearButton.set_disabled(false)
	unirseButton.set_disabled(false)
	
	_set_status(errorMsg, false)

func _on_hostearButton_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_server(DEFAULT_PORT, 1)
	if err != OK:
		return

	get_tree().set_network_peer(peer)
	hostearButton.set_disabled(true)
	unirseButton.set_disabled(true)
	
	_set_status("Esperando al jugador...", true)


func _on_unirseButton_pressed():
	var ip = ipHost.get_text()
	if not ip.is_valid_ip_address():
		_set_status("La IP es invalida", false)
		return

	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
	_set_status("Conectandose...", true)

func _set_status(text, isok):
	if isok:
		status_ok.set_text(text)
		status_fail.set_text("")
	else:
		status_ok.set_text("")
		status_fail.set_text(text)
