import WatchKit
import Foundation


class OptionsInterfaceController: WKInterfaceController {

    @IBOutlet var connectedLabel: WKInterfaceLabel!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }


    /**
     * Update the number of connected users.
     */
    func updateConnected() {
        let connected = String( DATA.connected )
        self.connectedLabel.setText( connected )
    }


    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
