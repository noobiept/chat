# Try it out #

[http://chat4321.herokuapp.com/](http://chat4321.herokuapp.com/)

![Web client](Images/readme_resized.png) ![iOS/watchOS clients](Images/iOS_watchOS_resized.png)


# Build #

Requires:

- `xcode` and `carthage` for the iOS/watchOS client.
- `node` for the web client.
- `swift` for the server section.

| Command | Description |
|---------|-------------|
| `npm install` | Install the web client and build dependencies. |
| `npm run dev` | Compiles and runs both the web client and server builds (go to `localhost:8000/` to try it out). |
| `npm run build` | Builds the release version of the web client and the server application. |
| `brew install carthage` | Install the iOS dependency manager. |
| `cd Client_iOS` then `carthage update` | Install the required dependencies. |

Open `/Client_iOS/chat.xcodeproj` to check the iOS/watchOS client project.


# Messages #

*Note:* &#124; is the pipe character, but isn't being rendered correctly in bitbucket.

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
