_Specifies how a level should be made and loaded._

A level is the map the player will see and interact with during the game, for example, a classroom, a whole village or a small janitor room. 

It should be made as a scene based on a LevelBase3D node (custom class implemented on `./scenes/environments/level_classes/level_base_3d.gd`, extends Node3D), containing the built world and a script, defining global scope methods, being one of them a initializer (used to prepare the level to be loaded as the main scene). 

There are two types of objects composing a level: inert and interactive. Inert objects are whatever the player doesn't need to interact with, like the floor and walls, animated or not. Interactive objects are the opposite, whatever the player _can_ interact with, like a NPCs or a door. Interactive objects are made normally, but they should be inside a LevelInteractable3D (custom class implemented on `./scenes/environments/level_classes/level_interactable_3d.gd`), which should contain a script defining the REQUESTs that are possible to be made from this object.

Inside the built world, some things aren't fixed, such as the NPCs' and special items' position. For these objects, some LevelPlaceholder3D and LevelPlaceholderGroup3D nodes (custom classs implemented on `./scenes/environments/level_classes/level_placeholder_3d.gd` and `./scenes/environments/level_classes/level_placeholder_group_3d.gd`) should be used. These node tells the client that, in a specific position and scale, an object from a list of allowed objects specified within the nodes' data should be placed. The object is specified by the server via the level instance data. 

The level loading process is as follows:
1. Something happens to trigger the level switch (e.g. the game starting or the player walking through a door). In most cases, the client will send a REQUEST packet to change the level, but it might not be necessary, such as when the game is starting, jumping directly to the SYNC packet. 
2. The server sends a RESPONSE packet to acknowledge the REQUEST.
3. The server instantiates the level's scene, calculate what should be placed and where based on the LevelPlaceholder3D nodes and create the level instance data string with everything the client needs to know to initialize/prepare the level for scene switching.
4. The server sends a SYNC packet containing which level should be loaded and the level instance data.
5. The client instantiates the specified level and calls `LevelBase3D.init(level_instance_data: String)` with the data received from the SYNC packet. The level is now ready to be loaded into the scene tree.
6. The client switches the active scene to the newly baked level using `LevelBase3D.load_as_scene(tree: SceneTree)`.
7. Done! =D

Obviously, it's not that simple in practice. Here are the details.

(If an example is needed, check `./scenes/environments/example_level/level.tscn`.)

LevelBase3D
===========

This class is the base for any level. It's essentially a classic Node3D, but it contains helper functions to deal with level placeholders and level interactables. These functions are used in three ocasions:
- when the server is baking the level;
- when the client is loading the level; and
- when the client or the server need to interact with a level interactable.

When the server is baking the level, the `LevelBase3D.bake(seed_hash: int)` function is called with the game seed's hash to generate the level instance data JSON object.

When the client is loading the level, 3 steps are taken:
- the level is instantiated from it's PackedScene (e.g. `./scenes/environments/classroom/level.tscn`);
- the level is initialized, i.e., it's placeholders are marked for replacement using `LevelBase3D.init(level_instance_data: String)` (the placeholders can only be replaced when the level is ready, so `init()` will await `ready` if `is_node_ready() == false`);
- the level is loaded as the current scene (even though it can be done manually, the helper `LevelBase3D.load_as_scene()` already does it for you without headaches).

When the client or the server need to interact with a level interactable, (...)

LevelPlaceholder3D and LevelPlaceholderGroup3D
==============================================

This is what makes levels versatile. A LevelPlaceholder3D takes the place of a Node3D that can vary based on the game seed. A LevelPlaceholderGroup3D groups multiple placeholders to help assigning scenes to them during level baking. 

When creating something that changes inside a level, you should:
- create a LevelPlaceholderGroup3D;
- create LevelPlaceholder3Ds inside the group and set their Tranform3Ds (they will be copied over to the replaced scene);
- on the editor, define the array of scenes the group should be replaced with (each placeholder will receive one scene to be replaced with);

Once it's done, when the level is baked, each placeholder will be assigned a scene path inside the level_instance_data string. The level_instance_data can now be passed to the LevelBase3D to replace all placeholders.

_Do not nest placeholders or placeholder groups as the game's behaviour on this case is undefined._

LevelInteractable3D
===================

(...)