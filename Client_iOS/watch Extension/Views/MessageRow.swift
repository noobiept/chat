import WatchKit


class MessageRow: NSObject {

    @IBOutlet var text: WKInterfaceLabel!
    @IBOutlet var group: WKInterfaceGroup!


    func update( _ message: Message ) {
        if message.type == .user {
            self.group.setBackgroundColor( .gray )
            self.text.setTextColor( .white )
        }

        else {
            let color = getUserColor( message.username, darker: false )
            self.text.setTextColor( color )
            self.group.setBackgroundColor( nil )
        }

        self.text.setText( message.message )
    }
}
