import WatchKit
import Foundation
import Starscream


class InterfaceController: WKInterfaceController, WebSocketDelegate {

    @IBOutlet var table: WKInterfaceTable!
    var socket: WebSocket!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        self.addTestMessages()

        let url = URL( string: "wss://chat4321.herokuapp.com/chat" )!
        self.socket = WebSocket( url: url )
        self.socket.delegate = self
        self.socket.connect()
    }


    func addTestMessages() {
        var testMessages: [String] = []

        for index in 0 ..< 20 {
            testMessages.append( "Test \(index)" )
        }

        self.table.setNumberOfRows( testMessages.count, withRowType: "MessageRow" )

        for (index, str) in testMessages.enumerated() {
            guard let row = self.table.rowController( at: index ) as? MessageRow else { continue }

            row.text.setText( str )
        }
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription ?? "")")
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("got some text: \(text)")
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }
}
