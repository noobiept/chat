import WatchKit
import Foundation
import Starscream


class InterfaceController: WKInterfaceController, ChatDelegate {

    @IBOutlet var table: WKInterfaceTable!

    var chat: Chat!


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        self.chat = Chat( "wss://chat4321.herokuapp.com/chat" )
        self.chat.delegate = self

        DATA.register( .message, {
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


    func setUsername( _ username: String ) {
        DATA.username = username

        let message = Message(
            time: Date(),
            username: username,
            message: "Connected!",
            type: .user
        )

        DATA.addMessage( message )
    }


    /**
     * Received a new message from the server, add it.
     */
    func addMessage( _ message: Message ) {
        DATA.addMessage( message )
    }


    /**
     * Send a message to the server.
     */
    func sendMessage( _ message: Message ) {
        self.chat.sendMessageToServer( message )
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


    func userJoined( _ message: Message ) {
        DATA.addMessage( message )
        DATA.connected += 1
    }


    func userLeft( _ message: Message ) {
        DATA.addMessage( message )
        DATA.connected -= 1
    }


    func connected( _ count: Int ) {
        DATA.connected = count
    }
}
