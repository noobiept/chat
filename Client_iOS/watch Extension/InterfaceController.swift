import WatchKit
import Foundation
import Starscream


class InterfaceController: WKInterfaceController, ChatDelegate {

    @IBOutlet var table: WKInterfaceTable!

    var chat: Chat!
    var messages: [Message] = []


    override func awake( withContext context: Any? ) {
        super.awake( withContext: context )

        self.chat = Chat( "wss://chat4321.herokuapp.com/chat" )
        self.chat.delegate = self
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
        print( "Username: \(username)" )
    }

    
    func addMessage( _ message: Message ) {
        let intIndex = self.messages.count
        let index = IndexSet( integer: intIndex )
        self.table.insertRows( at: index, withRowType: "MessageRow" )

        guard let row = self.table.rowController( at: intIndex ) as? MessageRow else { return }
        row.text.setText( message.message )

        self.messages.append( message )
    }


    func userJoined( _ message: Message ) {
        print( "User joined: \(message)" )
    }


    func userLeft( _ message: Message ) {
        print( "User left: \(message)" )
    }


    func connected( _ count: Int ) {
        print( "Connected: \(count)" )
    }
}
