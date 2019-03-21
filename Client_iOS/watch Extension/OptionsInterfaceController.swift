import WatchKit
import Foundation


class OptionsInterfaceController: WKInterfaceController {

    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var connectedLabel: WKInterfaceLabel!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        DATA.register( .connected, {
            self.updateData()
        })
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.updateData()
    }


    /**
     * Update the labels with the current data values (number of connected users, username, etc).
     */
    func updateData() {
        let username = DATA.username ?? "---"
        let connected = String( DATA.connected )

        self.usernameLabel.setText( username )
        self.connectedLabel.setText( connected )
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @IBAction func addMessage() {
        presentTextInputController( withSuggestions: [ "Hello there.", "Bye!", "Yes.", "No.", "Maybe." ], allowedInputMode: .allowEmoji, completion: {
            result in

            guard let result = result?.first as? String else { return }

            print( result )
        })
    }
}
