import UIKit
import OMAKOView

class PopUpViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Interface Builder Actions

    @IBAction func onPopUpTypeSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print(String(sender.selectedSegmentIndex))
        default:
            print(String(sender.selectedSegmentIndex))
        }
    }

    @IBAction func onHideTap(_ sender: UIButton) {
    }
}
