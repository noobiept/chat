# Build #

| Command | Description |
|---------|-------------|
| `swift build && .build/debug/chat` | Build and run the server. |
| `tsc -w` | Compile the typescript files. |


# Messages #

## Client ##

| Message | Description |
|---------|-------------|
| U&#124;(username) | Tells you what is your username. |
| C&#124;(connectedCount) | Tells you the number of connected users at the moment. |
| M&#124;(time)&#124;(username)&#124;(message) | Received a message. |
| J&#124;(username) | A user joined the chat. |
| L&#124;(username) | A user left the chat. |


## Server ##

| Message | Description |
|---------|-------------|
| R | A client is ready, send his username and the last chat messages. |
| M&#124;(username)&#124;(message) | Received a message. |
