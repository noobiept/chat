import WatchKit


class MessageRow: NSObject {

    @IBOutlet var text: WKInterfaceLabel!


    func update( _ message: Message ) {
        let color = getUserColor( message.username, darker: false )

        self.text.setTextColor( color )
        self.text.setText( message.message )
    }
}
