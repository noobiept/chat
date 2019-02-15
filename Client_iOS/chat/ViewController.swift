import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate {

    var socket: WebSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "wss://chat4321.herokuapp.com/chat")!
        self.socket = WebSocket(url: url)
        self.socket.delegate = self
        self.socket.connect()
    }


    deinit {
        self.socket.disconnect(forceTimeout: 0)
        self.socket.delegate = nil
    }
    
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected!")
    }
    
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Disconnected!")
    }
    
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received message: \(text)")
    }
    
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

