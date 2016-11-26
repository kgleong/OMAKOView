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

    fileprivate func displayTitleBodyPopUpWithFade() {
        popUpView = OMAKOPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.titleText = defaultTitleString
        let duration: TimeInterval = 5.0

        popUpView.bodyText = NSMutableAttributedString(
            string: "This pop up will automatically disappear in \(String(duration)) seconds)"
        )

        popUpView.display(parentView: view, withDuration: duration, completion: nil)
    }

    // MARK: - Interface Builder Actions

    @IBAction func onDisplayPopUp(_ sender: UIButton) {
        switch popUpTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            displayTitleOnlyPopUp()
        case 1:
            displayTitleBodyPopUpWithFade()
        default:
            print(String(popUpTypeSegmentedControl.selectedSegmentIndex))
        }
    }

    @IBAction func onHideTap(_ sender: UIButton) {
        guard let popUpView = popUpView else {
            return
        }

        popUpView.hide(onCompletion: nil)
    }
}
