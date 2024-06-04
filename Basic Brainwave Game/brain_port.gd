# BrainPort.gd
extends Node

# The UDPServer instance
var udp_server := UDPServer.new()
# The PacketPeerUDP instance to use for receiving data
var udp_peers = []
var packets = []
# The port to listen on
const PORT = 12345

var udp_connection : PacketPeerUDP = null
var btr = 0.0
var a = 0.0
# Define the signal
signal brain_data_received(concentration_level)

func _ready():
	# Start the UDPServer
	var result = udp_server.listen(PORT,"127.0.0.1")
	if result != OK:
		push_error("Unable to listen on port " + str(PORT))
		return
	print("Server is listening on port " + str(PORT))
	set_process(true)

	var cake = Callable()

	# Connect the signal to the ConcentrationBar node's method
	var concentration_bar = $ConcentrationBar
	cake = Callable(concentration_bar, "_on_BrainPort_brain_data_received")
	connect("brain_data_received", cake)

func _process(delta):
	# Poll the server to see if there are new connections
	udp_server.poll()
#	print('Polling successful')
	if udp_connection == null:
		if udp_server.is_connection_available():
			# Take the connection and assign it to udp_peer
			var udp_peer: PacketPeerUDP = udp_server.take_connection()
			udp_connection = udp_peer
			var packet = udp_peer.get_packet()
			print("New connection taken!")

			print("Accepted peer: %s:%s" % [udp_peer.get_packet_ip(), udp_peer.get_packet_port()])
			print("Received data: %s" % [packet.get_string_from_utf8()])
			# Reply so it knows we received the message.
			udp_peer.put_packet(packet)
			# Keep a reference so we can keep contacting the remote peer.
			#udp_peers.append(udp_peer)
		else:
			print("Not connected to port")
	else:
		var packet = udp_connection.get_packet()
		if packet.get_string_from_utf8().length() > 1:
#			print("Accepted peer: %s:%s" % [udp_connection.get_packet_ip(), udp_connection.get_packet_port()])
			print("Received data: %s" % [packet.get_string_from_utf8()])
			var bands = packet.get_string_from_utf8()
			bands = bands.get_slice("[", 1)
			# May need to change the 1 to a 2 above depending on how much streams per packet
			bands = bands.rstrip("]}")
			print("Bands: %s" % bands)
			var del = bands.get_slice(",", 0)
			var theta = bands.get_slice(",", 1)
			var alpha = bands.get_slice(",", 2)
			var beta = bands.get_slice(",", 3)
			var gamma = bands.get_slice(",", 4)
			print("Delta: %s" % del)
			print("Theta: %s" % theta)
			print("Alpha: %s" % alpha)
			print("Beta: %s" % beta)
			print("Gamma: %s" % gamma)
			beta = float(beta)
			theta = float(theta)
			btr = beta/theta
			a = float(alpha)
			print("BTR: %s" % btr)

