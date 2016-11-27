import UIKit
import OMAKOView

class PopUpViewController: UIViewController {
    @IBOutlet weak var popUpTypeSegmentedControl: UISegmentedControl!

    var popUpView: OMAKOPopUpView?

    var defaultTitleString: NSMutableAttributedString = NSMutableAttributedString(string: "Title Displayed Here")

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Pop Up View

    fileprivate func displayTitleOnlyPopUp() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.titleText = defaultTitleString
        popUpView.display(parentView: view, withDuration: nil, completion: nil)
    }

    fileprivate func displayBody() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.bodyText = NSMutableAttributedString(
            string: "Text for the pop up body displayed here."
        )

        popUpView.display(parentView: view, withDuration: nil) { print("Popup with body displayed") }
    }

    fileprivate func displayTitleBodyPopUpWithFade() {
        createPopUpView()

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

    fileprivate func displaySpinner() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.bodyText = NSMutableAttributedString(string: "Loading")
        popUpView.displaySpinner(parentView: view)
    }

    fileprivate func createPopUpView() {
        popUpView?.hide(completion: nil)
        popUpView = OMAKOPopUpView()
    }

    // MARK: - Interface Builder Actions

    @IBAction func onDisplayPopUp(_ sender: UIButton) {
        switch popUpTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            displayTitleOnlyPopUp()
        case 1:
            displayBody()
        case 2:
            displayTitleBodyPopUpWithFade()
        case 3:
            displaySpinner()
        default:
            print(String(popUpTypeSegmentedControl.selectedSegmentIndex))
        }
    }

    @IBAction func onHideTap(_ sender: UIButton) {
        guard let popUpView = popUpView else {
            return
        }

        popUpView.hide(completion: nil)
    }
}
