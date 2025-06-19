_Describes the sequence of events that lead the game during its execution on both the client and the server sides._

The game can be in one of two major phases: preparing and playing. The "preparing" phase is where the player creates a singleplayer/multiplayer room. The "playing" phase is, well, when the game is running normally.

Preparing phase
===============

On the preparing phase, there are two parts: the main menu and the lobby.

On the menu, the player have a button to create a new game and to load an existing game. 
- When creating a new game, the player should enter the game's seed, difficulty, player number and the name of the save (will be used to find, create and load the save file). Store these informations for now.
- When loading a new game, the player should select the save file from a list of saves found in the disk. They should be at `user://saves` and have the extension `.dat` (e.g. `user://saves/really_cool_save_file.dat`).

Having these informations, the server should be spawned with the listening port and the path to the save file, even if it does not exist. Right after it, the client should connect to the server and, on a successfull connection, load the lobby screen.

The lobby is where the players select their characters and names. Here, the server is inactive, only reacting to packets it receives and doing little to no processing. The following list explains what the server expects under which conditions and how it reacts with determinate packets.
- Player 1 joins: the server assigns it as the game authority, granting the player the ability to start the game when all necessary players are connected and ready. If the game is new (i.e. the save file does not exist or is empty), the server expects a SYNC with "seed" (String), difficulty (int from 1 to 3 inclusive) and "player_number" (int from 1 to 4 inclusive), and will not respond to any packets or allow any connections until it receives the SYNC.
- Any player joins: the server send a SYNC to _all clients_ with the players' names, characters and number (1 to 4) and expects a SYNC from the newly connected client with the player's name and character (being the list of characters predetermined, the client should be able to recognize which are taken and which are not based on the other player's choices, and if it sends a taken character or name anyways, the server will simply do nothing and ignore). When the server receives, it'll resend the SYNC with the players' data to all clients, this time including the newly connected player's data. If all required players send their names and characters, the server will include a "`ready=true`" on the SYNC to Player 1, signaling that they can start the game.
- Player 1 send a SYNC with "`start=true`": the server will send a SYNC to all clients with "`locked=true`" to signal it cannot receive any more changes to players data and will start the game. It then switches to the _Playing phase_.

Playing phase
=============

On the playing phase, both server and client are active and processing. The server, updating with VARIANCEs, generating and sending TICKs, processing REQUESTs and sending RESPONSEs. The client, handling user input, playing animations, generating and sending VARIANCEs, updating with TICKs, sending REQUESTs and handling RESPONSEs. Here, the server is running using the physics process.

Here is the game loop, including server and client:
- Client takes user input, displaying the pre-movement, getting all REQUESTs and generating the VARIANCE.
- Client handles the TICK instructions, updating the entities' positions, the player info and executing calls.
- Client executes the RESPONSEs calls.
- Client sends its packet queue to the server.
- Server processes REQUESTs, generating RESPONSEs and SYNCs, queueing level, entity and destiny updates.
- Server processes VARIANCEs, queueing entity updates.
- Server ticks the level, destiny and entities, queueing its updates.
- Server runs level, destiny and entity update queues, generating the client specific TICKs in the process. 
- Server sends its packet queue to the clients.
- Client checks if it got a SYNC. If it did, it should execute its calls, update itself and restarts its loop.

In reality, the client and the server loops are separate, but this summarize all loops. Anything beyond this is implementation detail, and is dependent on the developer's will.