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
    }


    /**
     * Open the project's website on the browser.
     */
    @IBAction func openWebsite( _ sender: Any ) {
        let url = URL( string: "https://bitbucket.org/drk4/chat/" )!
        UIApplication.shared.open( url )
    }


    /**
     * Save the options as we move away from the options screen.
     */
    override func viewWillDisappear( _ animated: Bool ) {
        super.viewWillDisappear( animated )

        if self.isMovingFromParent {
            let options = Options(
                showJoinLeftMessages: self.joinLeftSwitch.isOn,
                showUsernameInMessages: self.usernameSwitch.isOn
            )

            self.delegate?.updateOptions( options )
        }
    }
}
