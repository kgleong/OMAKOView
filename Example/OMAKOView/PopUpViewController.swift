import UIKit
import OMAKOView

class PopUpViewController: UIViewController {
    @IBOutlet weak var popUpTypeSegmentedControl: UISegmentedControl!

    var popUpView: OMAKOPopUpView?
    var defaultTitleString: NSMutableAttributedString = NSMutableAttributedString(string: "Enter a Title Here")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Pop Up View

    fileprivate func displayTitleOnlyPopUp() {
        popUpView = OMAKOPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.titleText = defaultTitleString

        popUpView.display(parentView: view, withDuration: nil, completion: nil)
    }

    // MARK: - Interface Builder Actions

    @IBAction func onDisplayPopUp(_ sender: UIButton) {
        switch popUpTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            displayTitleOnlyPopUp()
        default:
            print(String(popUpTypeSegmentedControl.selectedSegmentIndex))
        }
    }

    @IBAction func onHideTap(_ sender: UIButton) {
    }
}
