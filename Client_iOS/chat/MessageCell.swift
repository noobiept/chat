import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var dateFormatter: DateFormatter!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm" // hours:minutes
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func update(_ message: Message) {
        let timeString = self.dateFormatter.string(from: message.time)
        
        self.timeLabel.text = timeString
        self.usernameLabel.text = message.username
        self.messageLabel.text = message.message
    }
}
