import Foundation
import KituraWebSocket
import LoggerAPI
import Dispatch


struct Connection {
    var socket: WebSocketConnection
    var username: String

    init( socket: WebSocketConnection, username: String ) {
        self.socket = socket
        self.username = username
    }
}


class Chat: WebSocketService {

    // use the locks when reading/writing the shared data (from multiple threads)
    private var connections = [String: Connection]()
    private let connectionsLock = DispatchSemaphore( value: 1 )

    private var nextId = 0
    private var nextIdLock = DispatchSemaphore( value: 1 )

    private enum MessageType: Character {
        case textMessage = "M"
        case clientReady = "R"
    }

    private var lastMessages = [String]()
    private var lastMessagesLock = DispatchSemaphore( value: 1 )


    public func connected( connection: WebSocketConnection ) {

        lockNextId()
        let username = "username\(self.nextId)"
        self.nextId = self.nextId &+ 1    // add with overflow
        unlockNextId()

        lockConnections()
        self.connections[ connection.id ] = Connection( socket: connection, username: username )
        unlockConnections()

            // notify the rest of the users that this user joined
        self.sendMessageToAll( message: "J|\(username)", socket: connection )
    }


    public func disconnected( connection: WebSocketConnection, reason: WebSocketCloseReasonCode ) {

        lockConnections()
        let info = self.connections.removeValue( forKey: connection.id )
        unlockConnections()

        // notify the rest of the users that this user left the chat
        if let info = info {
            self.sendMessageToAll( message: "L|\(info.username)", socket: connection )
        }
    }


    public func received( message: Data, from: WebSocketConnection ) {
        from.close( reason: .invalidDataType, description: "This chat only accepts text messages." )

        lockConnections()
        self.connections.removeValue( forKey: from.id )
        unlockConnections()
    }


    public func received( message: String, from: WebSocketConnection ) {

        let messageCount = message.count
        if messageCount == 0 || messageCount > 200 {
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

            // confirm we have correct length
        if message.count < 3 {
            return
        }

            // remove the "M|" part
        let messageIndex = message.index( message.startIndex, offsetBy: 2 )
        let receivedMessage = message[ messageIndex... ]
        let time = self.getCurrentTime()

        lockConnections()
        let username = self.connections[ socket.id ]!.username
        unlockConnections()

        let sendMessage = "M|\(time)|\(username)|\(receivedMessage)"

        self.sendMessageToAll( message: sendMessage, socket: socket )
        self.saveMessage( message: sendMessage )
    }


    /**
     * Return the username associated with this socket connection, and the last chat messages.
     */
    private func clientIsReady( socket: WebSocketConnection ) {
        lockConnections()
        let username = self.connections[ socket.id ]!.username
        let connectedCount = self.connections.count
        unlockConnections()

        socket.send( message: "U|\(username)" )
        socket.send( message: "C|\(connectedCount)" )

            // send the last messages
        lockLastMessages()
        for message in self.lastMessages {
            socket.send( message: message )
        }
        unlockLastMessages()
    }


    /**
     * We save the last messages so we can send them when a new user connects (so he knows what everyone else was talking about before he joined).
     */
    private func saveMessage( message: String ) {
        lockLastMessages()
        self.lastMessages.append( message )

            // save the last 10 messages
            // if the array is full, then remove the first (older) one
        if self.lastMessages.count > 10 {
            self.lastMessages.remove( at: 0 )
        }
        unlockLastMessages()
    }


    /**
     * Send a message to all the chat users (apart from the current one).
     */
    private func sendMessageToAll( message: String, socket: WebSocketConnection ) {
        lockConnections()
        for ( connectionId, connection ) in self.connections {
            if connectionId != socket.id {
                connection.socket.send( message: message )
            }
        }
        unlockConnections()
    }


    /**
     * Return the time (in milliseconds) since 1 january 1970 (unix time).
     */
    private func getCurrentTime() -> Double {
        return Date().timeIntervalSince1970 * 1000
    }


    /**
     * Lock the 'connections' lock (decrement the semaphore by 1).
     */
    private func lockConnections() {
        _ = self.connectionsLock.wait( timeout: DispatchTime.distantFuture )
    }


    /**
     * Unlock the 'connections' lock (increment the semaphore by 1).
     */
    private func unlockConnections() {
        self.connectionsLock.signal()
    }


    /**
     * Lock the 'nextId' lock (decrement the semaphore by 1).
     */
    private func lockNextId() {
        _ = self.nextIdLock.wait( timeout: DispatchTime.distantFuture )
    }


    /**
     * Unlock the 'nextId' lock (increment the semaphore by 1).
     */
    private func unlockNextId() {
        self.nextIdLock.signal()
    }


    /**
     * Lock the 'lastMessages' lock (decrement the semaphore by 1).
     */
    private func lockLastMessages() {
        _ = self.lastMessagesLock.wait( timeout: DispatchTime.distantFuture )
    }


    /**
     * Unlock the 'lastMessages' lock (increment the semaphore by 1).
     */
    private func unlockLastMessages() {
        self.lastMessagesLock.signal()
    }
}
