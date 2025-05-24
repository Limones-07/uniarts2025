
## Provides a utility class to build a packet

class_name PacketBuilder
extends Node

enum PacketTypes {
	SYNC,
}

const SyncAttribute = {
	ERROR = {
		type = TYPE_STRING,
		id = "error",
		validation_method = "",
	},
	LEVEL = {
		type = TYPE_STRING,
		id = "level",
		validation_method = "",
	},
	LEVEL_INSTANCE_DATA = {
		type = TYPE_STRING,
		id = "level_instance_data",
		validation_method = "",
	},
	PLAYERS = {
		type = TYPE_PACKED_STRING_ARRAY,
		id = "players",
		validation_method = "",
	},
}

var _packet: Dictionary = {}

## Adds an attribute to the packet
func add_attribute(attribute: Dictionary, value: Variant) -> void:
	print(attribute)
	assert(attribute in SyncAttribute.values(), "Attribute isn't from %s packet" % _packet.type)
	assert(typeof(value) == attribute.type, "Attribute value isn't of correct type")
	assert(attribute.id not in _packet.keys(), "Attribute already added")
	if not attribute.validation_method.is_empty():
		assert(call(attribute.validation_method), "Attribute value failed validation")
	_packet[attribute.id] = value

## Returns the built packet as JSON
func json_export(ident: bool = false) -> String:
	var packet = _packet.duplicate(true)
	packet.erase("attribute_set")
	return JSON.stringify(packet, "\t" if ident else "")

func _init(packet_type: PacketTypes) -> void:
	if packet_type == PacketTypes.SYNC:
		self._packet.type = "sync"
		self._packet.attribute_set = SyncAttribute
	else:
		assert(false, "Invalid packet type received")
