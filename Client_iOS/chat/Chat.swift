import Foundation
import Starscream


struct Message {
    var time: Date
    var username: String
    var message: String
}


protocol ChatDelegate: class {
    func setUsername(_ username: String) -> Void
    func received(_ message: Message) -> Void
    func userLeft(_ message: Message) -> Void
    func userJoined(_ message: Message) -> Void
    func connected(_ count: Int) -> Void
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
    
    
    /**
     * Format: U|(username)
     */
    func userName(_ text: String) {
        let split = text.components(separatedBy: "|")
        
        self.delegate.setUsername(split[1])
    }
    
    
    /**
     * Format: C|(connectedCount)
     */
    func connectedCount(_ text: String) {
        let split = text.components(separatedBy: "|")
        let count = Int(split[1])
        
        if let count = count {
            self.delegate.connected(count)
        }
    }
    
    /**
     * Format: M|(time)|(username)|(message)
     */
    func receivedMessage(_ text: String) {
        let split = text.components(separatedBy: "|")
        guard let timestamp = Double(split[1]) else { return }

        let time = Date(timeIntervalSince1970: timestamp)
        let message = Message(time: time, username: split[2], message: split[3])

        self.delegate.received(message)
    }
    
    
    /**
     * Format: J|(username)
     */
    func userJoined(_ text: String) {
        let split = text.components(separatedBy: "|")
        let message = Message(time: Date(), username: split[1], message: "joined.")
        
        self.delegate.userJoined(message)
    }
    
    
    /**
     * Format: L|(username)
     */
    func userLeft(_ text: String) {
        let split = text.components(separatedBy: "|")
        let message = Message(time: Date(), username: split[1], message: "left.")
        
        self.delegate.userLeft(message)
    }
}
