import Foundation
import Starscream


protocol ChatDelegate {
    func received(message: String) -> Void
}


class Chat: WebSocketDelegate {
    var socket: WebSocket
    var delegate: ChatDelegate?
    
    init(_ serverUrl: String) {
        let url = URL(string: serverUrl)!
        
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
        self.delegate?.received(message: text)
    }
    
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
