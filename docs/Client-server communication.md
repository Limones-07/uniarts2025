_Defines everything related to the client-server communication... this line didn't help much, did it?_

Packets
=======

Before we start, consider a _packet_ a JSON string sent over the network with the purpose of getting or sending data.

There are 5 types of packets defined, being 2 used by the client and 3 by the server.
1. VARIANCE packet: used by the client to send the user's actions. Mainly used for movement.
2. REQUEST packet: used by the client to request something from a level object, like hurting, opening doors, giving items, talking to NPCs, responding to dialogs. It's basically calling a function from a level object.
3. TICK packet: used by the server to send what changed on the game relevant to a specific client. Mainly used for updating positions and updating level objects.
4. RESPONSE packet: used by the server to respond to a REQUEST. Varies based on the REQUEST. It's basically calling a function from a level object.
5. SYNC packet: used by the server to set the game state on a client. Mainly used for switching/updating levels.

The basic packet structure is:
```
{
  "type": "...", // one of VARIANCE, REQUEST, TICK, RESPONSE or SYNC
  "attribute1": "value1",
  "attribute2": [ "value1", "value2", "value3" ],
  "attribute3": true,
  "attribute4": { "subattribute": "value" }
}
```

To build a packet correctly, the PacketBuilder (custom class implemented on `./scenes/server/packet_builder.gd`) can be used. It's used on the server implementation to prevent programmer errors, but it isn't obligatory.

Errors parsing any of the non-optional attributes _must_ be treated as critical errors and disconnect the client.

Depending on the game's needs, more attributes can be added to each packet in the future.
#### VARIANCE packet specification
(For now, only used for the player's movement.)

- `"type": String` - Always set to "VARIANCE".
- `"movement": Array` - Contains two floats defining a two-dimensional vector that describes the player's movement on the floor. _The server does not validate any position, it is the client's responsibility to check collisions and invalid movements (probably using Godot's physics engine)._

Example packet:
```
{
  "type": "VARIANCE",
  "movement": [ 9.02, 0.0 ]
}
```

#### REQUEST packet specification
- `"type": String` - Always set to "REQUEST".
- `"id": String (optional)` - Can be specified to help the client define which RESPONSE is for which REQUEST, as it will be copied in the RESPONSE packet (see RESPONSE."id").
- `"object_id": String` - Specifies on which level object the request method is defined. It's copied in the RESPONSE packet to help identification (see RESPONSE."object_id").
- `"request": String` - Specifies the request method's name.
- `"parameters": Object` - Contains the parameters required by the request. If none are required, this should be `{}`.

When sent, the client should expect a RESPONSE corresponding to this REQUEST.

Example packet:
```
{
  "type": "REQUEST",
  "id": "i think this identifier is pretty unique, isn't it?",
  "object_id": "dante",
  "request": "talking_response",
  "parameters": {
	"option_index": 2
  }
}
```

#### TICK packet specification
- `"type": String` - Always set to "TICK".
- `"player_positions": Object` - Contains the positions of all players inside the player's level, including of themselves, being the keys the players' names and the values their positions.
- `"entity_positions": Object` - Contains the positions of all movable entities inside the player's level, being the keys the entities' object ids and the values their positions.
- `"level_calls": Object` - Contains calls to methods in the level's global scope. The keys specify the method to be called, and the values are the parameters, needing to be passed exactly as they are.

Example packet:
```
{
  "type": "TICK",
  
  "player_positions": {
	"lmnss": [ 123.65, 98.07 ],
	"ohyearsonist": [ 47.32, 203.0 ],
	"adeeme._": [ 82.5, 90.1 ]
  },
  
  "entity_positions": {
	"dante": [ 40.2, 200.0 ],
	"panther1": [ 120.0, 95.0 ],
	"panther2": [ 129.0, 100.0 ]
  },
  
  "level_calls": {
	"add_entities": [
	  {
		"id": "panther5".
		"scene_path": "res://scenes/enemies/panther.tscn"
		"position": [ 0.0, 0.0 ]
	  },
	  {
		"id": "panther6".
		"scene_path": "res://scenes/enemies/panther.tscn"
		"position": [ 0.0, 0.0 ]
	  }
	],
	"remove_entities": [
	  "panther3",
	  "panther4"
	],
	"object_calls": [
	  {
		"object_id": "dante",
		"method": "crouch"
	  }
	]
  }
}
```

#### RESPONSE packet specification
- `"type": String` - Always set to "RESPONSE".
- `"id": String (optional)` - Contains the specified id in the original REQUEST (a literal copy).
- `"object_id": String` - Specifies on which level object the response method is defined.
- `"response": String` - Specifies the response method's name.
- `"parameters": Object` - Contains the parameters required by the response. If none are required, this should be `{}`.

Example packet:
```
{
  "type": "RESPONSE",
  "id": "i think this identifier is pretty unique, isn't it?"
  "object_id": "dante",
  "response": "open_dialog",
  "parameters": {
	"text": "Thanks for helping me! Would you let me join you in your journey?",
	"options": [
	  "Yes, of course!",
	  "Yes... I guess...",
	  "I'm sorry, but... I need to go alone... I think?",
	  "You would only get in my way, as you are doing now."
	]
  }
}
```

#### SYNC packet specification
- `"type": String` - Always set to "SYNC".
- `"players": Array` - Contains the names of all players on this level.
- `"level": String` - Contains which level should be loaded (e.g. if the value is "classroom", the level's path is `./scenes/environments/classroom/level.tscn`). 
- `"level_instance_data": String` - Contains a JSON string with all the data necessary to bake the level. It should be passed directly to LevelBaker.
- `"level_setup_calls": Object` - Contains calls to methods in the level's global scope (see TICK."level_calls").

Example packet:
```
{
  "type": "SYNC",
  // "error": "Room is full!",
  "players": [
	"lmnss",
	"ohyearsonist",
	"adeeme._"
  ],
  
  "level": "classroom",
  "level_instance_data": "{ ... }",
  "level_setup_calls": {
	"add_entities": [ ... ],
	"object_calls": [ ... ]
	// ...
  }
}
```
