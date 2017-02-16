# Build #

- `swift build && .build/debug/chat`  # Build and run the server.
- `tsc -w`  # Compile the typescript files.

# Messages #

## Client ##

- `"U|(username)"` -- Tells you what is your username.
- `"M|(username)|(message)"` -- Received a message.
- `"J|(username)"` -- A user joined the chat.
- `"L|(username)"` -- A user left the chat.

## Server ##

- `"R"` -- A client is ready, send his username and the last chat messages.
- `"M|(username)|(message)"` -- Received a message.