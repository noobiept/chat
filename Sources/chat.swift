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


    public func connected( connection: WebSocketConnection ) {

        let username = "username\(nextId)"
        nextId = nextId &+ 1    // add with overflow

        connections[ connection.id ] = Connection( socket: connection, username: username )
        
        // notify the user what is his username
        connection.send( message: "U|\(username)" )
        Log.info( "U|\(username)" )
    }

    public func disconnected( connection: WebSocketConnection, reason: WebSocketCloseReasonCode ) {
        connections.removeValue( forKey: connection.id )
        Log.info( "A user left" )
    }

    public func received( message: Data, from: WebSocketConnection ) {
        from.close( reason: .invalidDataType, description: "Chat-Server only accepts text messages" )

        connections.removeValue( forKey: from.id )
    }

    public func received( message: String, from: WebSocketConnection ) {

        let username = self.connections[ from.id ]!.username
        let sendMessage = "M|\(username)|\(message)"

        for ( connectionId, connection ) in connections {
            if connectionId != from.id {
                connection.socket.send( message: sendMessage )
            }
        }
    }
}