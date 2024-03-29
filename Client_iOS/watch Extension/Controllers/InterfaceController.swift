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

        NotificationCenter.default.addObserver( self, selector: #selector( self.openThisPage ), name: Notification.Name( "OpenChatPage" ), object: nil )
    }


    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

        // when switching pages watchOS scrolls the table back to the top
        // so we scroll it again back to the end
        // its in 'didDeactivate' instead of 'willActivate' so it doesn't have the scroll animation
        self.scrollToBottom()
    }


    /**
     * Add the given message at the end of the table.
     */
    func appendMessage( _ message: Message ) {
        let intIndex = self.table.numberOfRows
        let index = IndexSet( integer: intIndex )

        self.table.insertRows( at: index, withRowType: "MessageRow" )

        guard let row = self.table.rowController( at: intIndex ) as? MessageRow else { return }
        row.update( message )

        // check if we need to cut the number of rows in the table (have a maximum number of messages/rows that we keep track of)
        if let range = AppData.chat.clearMessageListIfNeeded() {
            let index = IndexSet( integer: range.startIndex )

            // remove from the start position the range count
            for _ in range {
                self.table.removeRows( at: index )
            }
        }

        self.scrollToBottom()
    }


    /**
     * Scroll to the last message (so its readable).
     */
    func scrollToBottom() {
        let lastIndex = self.table.numberOfRows - 1
        self.table.scrollToRow( at: lastIndex )
    }


    /**
     * Open the chat page.
     */
    @objc func openThisPage( notification: Notification ) {
        self.becomeCurrentPage()
    }
}
