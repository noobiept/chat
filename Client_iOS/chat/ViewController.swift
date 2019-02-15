import UIKit
import Starscream

class ViewController: UIViewController, WebSocketDelegate, UITableViewDataSource, UITableViewDelegate {

    var socket: WebSocket!
    var messages = ["test1", "test2", "test3"]

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var connectedCountLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = self.messages[indexPath.row]
        
        cell.textLabel?.text = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
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

