_Specifies how a level should be made and loaded._

A level is the map the player will see and interact with during the game, for example, a classroom, a whole village or a small janitor room. 

It should be made as a scene based on a LevelBase3D node (custom class implemented on `./scenes/levels/level_base_3d.gd`, extends Node3D), containing the built world and a script, defining global scope methods, being one of them a initializer (used to prepare the level to be loaded as the main scene). 

There are two types of objects composing a level: inert and interactive. Inert objects are whatever the player doesn't need to interact with, like the floor and walls, animated or not. Interactive objects are the opposite, whatever the player _can_ interact with, like a NPCs or a door. Interactive objects are made normally, but they should be inside a LevelInteractable3D (custom class implemented on `./scenes/levels/level_interactable_3d.gd`), which should contain a script defining the REQUESTs that are possible to be made from this object.

Inside the built world, some things aren't fixed, such as the NPCs' and special items' position. For these objects, a LevelPlaceholder3D node (custom class implemented on `./scenes/levels/level_placeholder_3d.gd`) should be used. This node tells the client that, in it's position, an object from a list of allowed objects specified within the node's data should be placed. This object is specified by the server via the SYNC packet. 

The level loading process is as follows:
1. Something happens to trigger the level switch (e.g. the game starting or the player walking through a door). In most cases, the client will send a REQUEST packet to change the level, but it might not be necessary, such as when the game is starting, jumping directly to the SYNC packet. 
2. The server sends a RESPONSE packet to acknowledge the REQUEST.
3. The server instantiates the level's scene, calculate what should be placed and where based on the LevelPlaceholder3D nodes and create the level data string with everything the client needs to know to "bake" the level for scene switching.
4. The server sends a SYNC packet containing which level should be loaded and the level instance data.
5. The client calls `LevelBaker.bake(level: String, level_instance_data: String)` (static method implemented on `./scenes/levels/level_baker.gd`) with the data received from the SYNC packet. The return value is the PackedScene of the level with all placeholder nodes substituted with their respective object.
6. The client switches the active scene to the newly baked level.
7. Done! =D

Obviously, it's not that simple in practice. Here are the details.