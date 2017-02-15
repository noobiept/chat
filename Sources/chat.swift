import Foundation
import KituraWebSocket
import LoggerAPI


struct Connection {
    var socket: WebSocketConnection
    var username: String

    init( socket: WebSocketConnection, username: String ) {
        self.socket = socket
        self.username = username
    }
}


class Chat: WebSocketService {

    private var connections = [String: Connection]()
    private var nextId = 0
    private enum MessageType: Character {
        case textMessage = "M"
        case clientReady = "R"
    }
    private var lastMessages = [String]()


    public func connected( connection: WebSocketConnection ) {

        let username = "username\(nextId)"
        nextId = nextId &+ 1    // add with overflow

        connections[ connection.id ] = Connection( socket: connection, username: username )

            // notify the user what is his username
        connection.send( message: "U|\(username)" )
    }


    public func disconnected( connection: WebSocketConnection, reason: WebSocketCloseReasonCode ) {
        connections.removeValue( forKey: connection.id )
    }


    public func received( message: Data, from: WebSocketConnection ) {
        from.close( reason: .invalidDataType, description: "Chat-Server only accepts text messages" )

        connections.removeValue( forKey: from.id )
    }


    public func received( message: String, from: WebSocketConnection ) {

        if message.characters.count == 0 {
            return
        }

        let type = message[ message.startIndex ]

        switch type {
            case MessageType.clientReady.rawValue:
                clientIsReady( socket: from )

            case MessageType.textMessage.rawValue:
                receivedTextMessage( message: message, socket: from )

            default:
                return
        }
    }


    /**
     * Received a text message. Send it to all the other users.
     * Message format: "M|(message)"
     */
    private func receivedTextMessage( message: String, socket: WebSocketConnection ) {
            // remove the "M|" part
        let messageIndex = message.index( message.startIndex, offsetBy: 2 )
        let receivedMessage = message.substring( from: messageIndex )

        let username = self.connections[ socket.id ]!.username
        let sendMessage = "M|\(username)|\(receivedMessage)"

        for ( connectionId, connection ) in connections {
            if connectionId != socket.id {
                connection.socket.send( message: sendMessage )
            }
        }

        self.saveMessage( message: sendMessage )
    }


    /**
     * Return the username associated with this socket connection, and the last chat messages.
     */
    private func clientIsReady( socket: WebSocketConnection ) {
        let username = self.connections[ socket.id ]!.username
        socket.send( message: "U|\(username)" )

            // send the last messages
        for message in self.lastMessages {
            socket.send( message: message )
        }
    }


    /**
     * We save the last messages so we can send them when a new user connects (so he knows what everyone else was talking about before he joined).
     */
    private func saveMessage( message: String ) {
        self.lastMessages.append( message )

            // save the last 10 messages
            // if the array is full, then remove the first (older) one
        if self.lastMessages.count > 10 {
            self.lastMessages.remove( at: 0 )
        }
    }
}