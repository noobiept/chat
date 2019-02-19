import UIKit
import Starscream

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ChatDelegate, OptionsDelegate {

    let inputLength = 200   // maximum string length we can accept for a message
    let scrollMargin = 300  // margin from the bottom where we scroll into view on new messages
    let maxMessages = 100   // maximum number of messages we keep track of in the table view

    var chat: Chat!
    var messages: [Message] = []
    var username: String?
    var connectedCount = 0
    var options = Options()

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var connectedCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
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

        cell.update(message, self.options.showUsernameInMessages)

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    /**
     * Copy the message to the pasteboard and deselect the cell.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        UIPasteboard.general.string = message.message

        self.messagesTableView.deselectRow(at: indexPath, animated: true)
    }


    /**
     * Add a new message to the messages table view.
     */
    func addMessage(_ message: Message) {
        self.messages.append(message)
        self.clearMessageListIfNeeded()

        self.messagesTableView.reloadData()
        self.scrollIfNeeded()
    }


    /**
     * Only keep a certain number of messages in the table view.
     * Once we reach the limit clear a few of them.
     */
    func clearMessageListIfNeeded() {
        let count = self.messages.count

        if count >= self.maxMessages {
            let half = self.maxMessages / 2
            self.messages.removeSubrange(0..<half)
        }
    }


    /**
     * Scroll to the bottom if we're within the margin off the bottom, so you can see the new messages imediately.
     * If above that margin, don't scroll to let the user read older messages.
     */
    func scrollIfNeeded() {
        let margin = CGFloat(self.scrollMargin)
        let frameHeight = self.messagesTableView.frame.height
        let distanceFromBottom = self.messagesTableView.contentSize.height - self.messagesTableView.contentOffset.y

        let diff = distanceFromBottom - frameHeight

        if diff >= 0 && diff < margin {
            self.scrollToBottom()
        }
    }


    /**
     * Scroll to the last message (so its readable).
     */
    func scrollToBottom() {
        let lastRow = self.messagesTableView.numberOfRows(inSection: 0) - 1
        let lastIndex = IndexPath(row: lastRow, section: 0)
        self.messagesTableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
    }


    func userJoined(_ message: Message) {
        self.connected(self.connectedCount + 1)

        if self.options.showJoinLeftMessages {
            self.addMessage(message)
        }
    }


    func userLeft(_ message: Message) {
        self.connected(self.connectedCount - 1)

        if self.options.showJoinLeftMessages {
            self.addMessage(message)
        }
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
           message.count > 0 && message.count <= self.inputLength {

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

            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.view.layoutIfNeeded()
                },
                completion: {
                    (_) in
                    self.scrollToBottom()
                }
            )
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Options" {
            let optionsTableView = segue.destination as! OptionsTableViewController
            optionsTableView.delegate = self
        }
    }


    func getOptions() -> Options {
        return self.options
    }


    func updateOptions(_ options: Options) {
        self.options = options
        self.messagesTableView.reloadData()
    }
}

