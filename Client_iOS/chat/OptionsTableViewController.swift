import UIKit

class OptionsTableViewController: UITableViewController {

    weak var delegate: OptionsDelegate?

    @IBOutlet weak var joinLeftSwitch: UISwitch!
    @IBOutlet weak var usernameSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let delegate = self.delegate {
            let options = delegate.getOptions()

            self.joinLeftSwitch.isOn = options.showJoinLeftMessages
            self.usernameSwitch.isOn = options.showUsernameInMessages
        }

        self.joinLeftSwitch.addTarget(self, action: #selector(self.joinLeftChange), for: .valueChanged)
        self.usernameSwitch.addTarget(self, action: #selector(self.usernameChange), for: .valueChanged)
    }

    @IBAction func openWebsite(_ sender: Any) {
        let url = URL(string: "https://bitbucket.org/drk4/chat/")!
        UIApplication.shared.open(url)
    }


    @objc func joinLeftChange(sender: UISwitch) {
        self.delegate?.updateShowJoinLeft(sender.isOn)
    }

    @objc func usernameChange(sender: UISwitch) {
        self.delegate?.updateShowUsername(sender.isOn)
    }
}
