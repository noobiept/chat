import Foundation


enum AppDataEvent {
    case connected
    case username
    case message
}


class AppData: ChatDelegate {

    static let chat = AppData( url: "wss://chat4321.herokuapp.com/chat" )

    private var _callbacks: [AppDataEvent: [(Any?) -> Void]] = [:]
    private var _connected = 0
    private var _username: String?
    private var _messages: [Message] = []
    private var _chat: Chat!

    var connected: Int {
        get {
            return self._connected
        }

        set( value ) {
            self._connected = value
            self.callListeners( .connected )
        }
    }

    var username: String? {
        get {
            return self._username
        }

        set( value ) {
            self._username = value
            self.callListeners( .username )
        }
    }

    var messages: [Message] {
        return self._messages
    }


    private init( url: String ) {
        self._chat = Chat( url )
        self._chat.delegate = self
    }


    /**
     * Register an event listener to be called when the associated data is updated.
     */
    func register( _ event: AppDataEvent, _ callback: @escaping ( Any? ) -> Void) {
        if var callbacks = self._callbacks[ event ] {
            callbacks.append( callback )
        }

        else {
            self._callbacks[ event ] = [
                callback
            ]
        }
    }


    /**
     * Call all the associated listeners of the given event.
     */
    private func callListeners( _ event: AppDataEvent, _ data: Any? = nil ) {
        if let callbacks = self._callbacks[ event ] {
            for callback in callbacks {
                callback( data )
            }
        }
    }


    /**
     * Send a message to the server.
     */
    func sendMessage( _ message: Message ) {
        self._chat.sendMessageToServer( message )
        self.addMessage( message )
    }


    /**
     * The username we receive its the one associated with this user (we receive it shortly after connecting to the server).
     */
    func setUsername(_ username: String) {
        self.username = username

        let message = Message(
            time: Date(),
            username: username,
            message: "Connected!",
            type: .user
        )

        self.addMessage( message )
    }


    /**
     * Received a new message from the server, add it.
     * Can also be called directly to add a message to the list.
     */
    func addMessage( _ message: Message ) {
        self._messages.append( message )
        self.callListeners( .message, message )
    }


    /**
     * A user has joined the chat, update the number of connected users.
     */
    func userJoined(_ message: Message) {
        self.connected += 1
    }


    /**
     * A user has left the chat, update the number of connected users.
     */
    func userLeft(_ message: Message) {
        self.connected -= 1
    }


    /**
     * Received shortly after connecting to the server, tells us the number of existing users in the chat as we enter it.
     */
    func connected(_ count: Int) {
        self.connected = count
    }
}
