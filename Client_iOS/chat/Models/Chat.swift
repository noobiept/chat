import Foundation
import Starscream


enum MessageType {
    case user       // our own messages
    case otherUsers // other user messages
    case joined     // a user has joined the chat
    case left       // a user has left the chat
}

struct Message {
    var time: Date
    var username: String
    var message: String
    var type: MessageType
}

protocol ChatDelegate: class {
    func setUsername( _ username: String ) -> Void
    func addMessage( _ message: Message ) -> Void
    func userJoined( _ message: Message ) -> Void
    func userLeft( _ message: Message ) -> Void
    func usersCount( _ count: Int ) -> Void     // called with the number of initial users that are active in the chat
    func disconnected() -> Void                 // called when the connection is lost
}


class Chat: WebSocketDelegate {
    var socket: WebSocket
    weak var delegate: ChatDelegate!
    
    init( _ serverUrl: String ) {
        let url = URL( string: serverUrl )!
        
        self.socket = WebSocket( url: url )
        self.socket.delegate = self
        self.socket.connect()
    }
    
    
    deinit {
        self.socket.disconnect( forceTimeout: 0 )
        self.socket.delegate = nil
    }


    /**
     * Attempt to connect again in 5 seconds.
     */
    func reconnect() {
        DispatchQueue.main.asyncAfter( deadline: .now() + .seconds( 5 ), execute: {
            self.socket.connect()
        })
    }

    
    func websocketDidConnect( socket: WebSocketClient ) {
        print( "Connected!" )
        self.sendToServer( "R" )    // signal the server that we're ready
    }
    
    
    func websocketDidDisconnect( socket: WebSocketClient, error: Error? ) {
        print( "Disconnected!" )
        self.delegate.disconnected()
        self.reconnect()
    }
    

    /**
     * We received a text message from the server via the websocket. The first character signals what type of message it is.
     */
    func websocketDidReceiveMessage( socket: WebSocketClient, text: String ) {
        let code = text.prefix( 1 )

        switch code {
        case "U":
            self.userName(text)
        
        case "C":
            self.connectedCount(text)
            
        case "M":
            self.receivedMessage(text)
            
        case "J":
            self.userJoined(text)
        
        case "L":
            self.userLeft(text)
            
        default:
            break
        }
    }
    
    
    func websocketDidReceiveData( socket: WebSocketClient, data: Data ) {
        
    }
    
    
    /**
     * Format: U|(username)
     */
    func userName( _ text: String ) {
        let split = text.components( separatedBy: "|" )
        
        self.delegate.setUsername( split[ 1 ] )
    }
    
    
    /**
     * Format: C|(connectedCount)
     * Tells us the initial number of connected users. After that the number is managed based on the user left/joined messages we receive.
     */
    func connectedCount( _ text: String ) {
        let split = text.components( separatedBy: "|" )
        let count = Int( split[ 1 ] )

        if let count = count {
            self.delegate.usersCount( count )
        }
    }


    /**
     * Format: M|(time)|(username)|(message)
     */
    func receivedMessage( _ text: String ) {
        let split = text.components( separatedBy: "|" )
        guard let timestamp = Double( split[ 1 ] ) else { return }

        let time = Date( timeIntervalSince1970: timestamp / 1000 )
        let message = Message( time: time, username: split[ 2 ], message: split[ 3 ], type: .otherUsers )

        self.delegate.addMessage( message )
    }
    
    
    /**
     * Format: J|(username)
     */
    func userJoined( _ text: String ) {
        let split = text.components( separatedBy: "|" )
        let message = Message( time: Date(), username: split[ 1 ], message: "joined.", type: .joined )
        
        self.delegate.userJoined( message )
    }
    
    
    /**
     * Format: L|(username)
     */
    func userLeft( _ text: String ) {
        let split = text.components( separatedBy: "|" )
        let message = Message( time: Date(), username: split[ 1 ], message: "left.", type: .left )
        
        self.delegate.userLeft( message )
    }
    
    
    /**
     * Send a string to the server (needs to be in a proper format).
     */
    func sendToServer( _ text: String ) {
        self.socket.write( string: text )
    }
    
    
    /**
     * Send a user message to the server.
     */
    func sendMessageToServer( _ message: Message ) {
        self.sendToServer( "M|\(message.message)" )
    }
}
