import UIKit


class MessageCell: UITableViewCell {
    
    static let userColor = UIColor.purple.withAlphaComponent( 0.1 )
    static let joinedColor = UIColor.green.withAlphaComponent( 0.1 )
    static let leftColor = UIColor.red.withAlphaComponent( 0.1 )

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var usernameStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var dateFormatter: DateFormatter!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm" // hours:minutes
    }

    
    override func setSelected( _ selected: Bool, animated: Bool ) {
        super.setSelected( selected, animated: animated )
    }
    

    /**
     * Update the message cell UI elements based on the given 'Message' data.
     * The username/time elements can be optionally hidden.
     */
    func update( _ message: Message, _ showUsername: Bool ) {
        let timeString = self.dateFormatter.string( from: message.time )
        
        self.timeLabel.text = timeString
        self.usernameLabel.text = message.username
        self.messageLabel.text = message.message

        self.usernameStackView.isHidden = !showUsername
        self.usernameLabel.textColor = getUserColor( message.username )

        // change the background color based on the type of message
        var color: UIColor? = nil
        
        switch message.type {
            case .joined:
                color = MessageCell.joinedColor

            case .left:
                color = MessageCell.leftColor
            
            case .user:
                color = MessageCell.userColor
            
            default:
                color = nil
        }

        self.contentView.backgroundColor = color
    }
}
