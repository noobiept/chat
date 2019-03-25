import WatchKit
import Foundation


class OptionsInterfaceController: WKInterfaceController {

    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var connectedLabel: WKInterfaceLabel!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        AppData.chat.register( .connected, {
            data in
            self.updateConnected()
        })
        AppData.chat.register( .username, {
            data in
            self.updateUsername()
        })
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }


    /**
     * Update the UI with the current number of connected users.
     */
    func updateConnected() {
        let connected = String( AppData.chat.connected )
        self.connectedLabel.setText( connected )
    }


    /**
     * Update the UI with the current username.
     */
    func updateUsername() {
        let username = AppData.chat.username ?? "---"
        self.usernameLabel.setText( username )
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func addMessage() {
        presentTextInputController( withSuggestions: [ "Hello there.", "Bye!", "Yes.", "No.", "Maybe." ], allowedInputMode: .allowEmoji, completion: {
            result in

            guard let result = result?.first as? String else { return }
            guard result.count <= AppData.chat.inputLength else { return }
            guard let username = AppData.chat.username else { return }

            let message = Message(
                time: Date(),
                username: username,
                message: result,
                type: .user
            )
            AppData.chat.sendMessage( message )

            // change to the 'chat' page (so we can see the message we just sent)
            NotificationCenter.default.post( name: Notification.Name( "OpenChatPage" ), object: nil )

            // the interface isn't dismissed when adding some emotes
            // so we manually dismiss it to make sure we go back to the chat page
            self.dismissTextInputController()
        })
    }
}
