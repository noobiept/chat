import WatchKit
import Foundation
import Starscream


class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        AppData.chat.register( .message, {
            data in
            self.appendMessage( data as! Message )
        })
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    /**
     * Add the given message at the end of the table.
     */
    func appendMessage( _ message: Message ) {
        let intIndex = self.table.numberOfRows
        let index = IndexSet( integer: intIndex )

        self.table.insertRows( at: index, withRowType: "MessageRow" )

        guard let row = self.table.rowController( at: intIndex ) as? MessageRow else { return }
        row.text.setText( message.message )
    }
}
