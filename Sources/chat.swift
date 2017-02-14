import Foundation
import KituraWebSocket
import LoggerAPI


class Chat: WebSocketService {
    private var connections = [String: WebSocketConnection]()

    public func connected( connection: WebSocketConnection ) {
        connections[ connection.id ] = connection
        Log.info( "New user connected." )
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
        Log.info( "Received a message: \(message)" )

        for ( connectionId, connection ) in connections {
            if connectionId != from.id {
                connection.send( message: message )
            }
        }
    }
}