import WatchKit
import Foundation


class OptionsInterfaceController: WKInterfaceController {

    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var connectedLabel: WKInterfaceLabel!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        DATA.register( .connected, {
            data in
            self.updateConnected()
        })
        DATA.register( .username, {
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
        let connected = String( DATA.connected )
        self.connectedLabel.setText( connected )
    }


    /**
     * Update the UI with the current username.
     */
    func updateUsername() {
        let username = DATA.username ?? "---"
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
            guard let username = DATA.username else { return }

            let message = Message(
                time: Date(),
                username: username,
                message: result,
                type: .user
            )
            DATA.addMessage( message )
        })
    }
}
