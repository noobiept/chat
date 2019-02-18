import UIKit

class OptionsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func openWebsite(_ sender: Any) {
        let url = URL(string: "https://bitbucket.org/drk4/chat/")!
        UIApplication.shared.open(url)
    }
}
