import UIKit
import Starscream

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChatDelegate {

    var chat: Chat!
    var messages = ["test1", "test2", "test3"]

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var connectedCountLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chat = Chat("wss://chat4321.herokuapp.com/chat")
        self.chat.delegate = self
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
    
    
    func received(message: String) {
        self.messages.append(message)
        self.messagesTableView.reloadData()
    }
    
    
    
}

