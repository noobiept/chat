import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        self.addTestMessages()
    }


    func addTestMessages() {
        var testMessages: [String] = []

        for index in 0 ..< 20 {
            testMessages.append( "Test \(index)" )
        }

        self.table.setNumberOfRows( testMessages.count, withRowType: "MessageRow" )

        for (index, str) in testMessages.enumerated() {
            guard let row = self.table.rowController( at: index ) as? MessageRow else { continue }

            row.text.setText( str )
        }
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
