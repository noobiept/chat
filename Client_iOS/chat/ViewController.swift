import UIKit
import Starscream

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ChatDelegate {

    let inputLength = 200   // maximum string length we can accept for a message
    var chat: Chat!
    var messages: [Message] = []
    var username: String?
    var connectedCount = 0

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var connectedCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var menuBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.chat = Chat("wss://chat4321.herokuapp.com/chat")
        self.chat.delegate = self
        self.inputTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = self.messages[indexPath.row]

        cell.update(message)

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    /**
     * Add a new message to the messages table view.
     */
    func addMessage(_ message: Message) {
        self.messages.append(message)
        self.messagesTableView.reloadData()
    }


    func userJoined(_ message: Message) {
        self.connected(self.connectedCount + 1)
        self.addMessage(message)
    }


    func userLeft(_ message: Message) {
        self.connected(self.connectedCount - 1)
        self.addMessage(message)
    }


    func setUsername(_ username: String) {
        self.username = username
        self.usernameLabel.text = username

        let message = Message(time: Date(), username: username, message: "Welcome to the chat!", type: .user)
        self.addMessage(message)
    }


    /**
     * Update the number of connected users UI element.
     */
    func connected(_ count: Int) {
        self.connectedCountLabel.text = "Connected: \(count)"
        self.connectedCount = count
    }


    /**
     * Deal with the user input.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let message = textField.text

        if let message = message,
           let username = self.username,
           message.count > 0 && message.count <= 200 {

            let message = Message(time: Date(), username: username, message: message, type: .user)

            self.chat.sendMessageToServer(message)
            self.addMessage(message)

            textField.text = "" // clear the input after every new message
        }

        self.inputTextField.resignFirstResponder()
        return true
    }


    /**
     * Limit the input to the maximum length that is accepted by the server.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length

        return count <= self.inputLength
    }
    
    
    /**
     * Re-position the bottom menu to accomodate for the space the keyboard will use.
     */
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.menuBottomConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    /**
     * Reset the menu position when the keyboard is hidden.
     */
    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.menuBottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}

