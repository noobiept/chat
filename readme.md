# Build #

| Command | Description |
|---------|-------------|
| `swift build && .build/debug/chat` | Build and run the server. |
| `tsc -w` | Compile the typescript files. |


# Messages #

## Client ##

| Message | Description |
|---------|-------------|
| `U|(username)` | Tells you what is your username. |
| `C|(connectedCount)` | Tells you the number of connected users at the moment. |
| `M|(time)|(username)|(message)` | Received a message. |
| `J|(username)` | A user joined the chat. |
| `L|(username)` | A user left the chat. |


## Server ##

| Message | Description |
|---------|-------------|
| `R` | A client is ready, send his username and the last chat messages. |
| `M|(username)|(message)` | Received a message. |
