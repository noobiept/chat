import Foundation
import Starscream


protocol ChatDelegate: class {
    func received(message: String) -> Void
}


class Chat: WebSocketDelegate {
    var socket: WebSocket
    weak var delegate: ChatDelegate!
    
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
        let code = text.prefix(1)

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
    
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    
    func userName(_ text: String) {
        
    }
    
    
    func connectedCount(_ text: String) {
        
    }
    
    /**
     * Format: M|(time)|(username)|(message)
     */
    func receivedMessage(_ text: String) {
        let split = text.components(separatedBy: "|")
        let time = split[1]
        let username = split[2]
        let message = split[3]

        self.delegate.received(message: message)
    }
    
    
    func userJoined(_ text: String) {
        
    }
    
    
    func userLeft(_ text: String) {
        
    }
}
