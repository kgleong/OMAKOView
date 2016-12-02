import UIKit
import OMAKOView

class PopUpViewController: UIViewController {
    @IBOutlet weak var textPopUpTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var spinnerTypeSegmentedControl: UISegmentedControl!

    var activeSegmentedControl: UISegmentedControl?
    var inactiveSegmentedControl: UISegmentedControl?

    var popUpView: OMAKOPopUpView?

    var defaultTitleString: NSMutableAttributedString = NSMutableAttributedString(string: "Title Displayed Here")

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        activeSegmentedControl = textPopUpTypeSegmentedControl
        inactiveSegmentedControl = spinnerTypeSegmentedControl
        spinnerTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }

        override open func viewWillAppear(_ animated: Bool) {
        popUpView?.hide(completion: nil)
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

        // Passes in an on completion handler that logs a message.
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

    fileprivate func displaySquareSpinner() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.bodyText = NSMutableAttributedString(string: "Loading")
        popUpView.displaySpinner(parentView: view)
    }

    fileprivate func displaySquareSpinnerWithTitle() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        popUpView.titleText = NSMutableAttributedString(string: "Loading")
        popUpView.bodyText = NSMutableAttributedString(string: "Your request will be completed shortly.")
        popUpView.displaySpinner(parentView: view)
    }

    fileprivate func displayStarSpinner() {
        createPopUpView()

        guard let popUpView = popUpView else {
            return
        }

        // For now, should log an error message.
        popUpView.display(parentView: view)
    }

    fileprivate func createPopUpView() {
        popUpView?.hide(completion: nil)
        popUpView = OMAKOPopUpView()
        popUpView!.layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).cgColor
        popUpView!.layer.borderWidth = 2
    }

    // MARK: - Interface Builder Actions

    @IBAction func onSegmentedValueChange(_ sender: UISegmentedControl) {
        setActive(segmentedControl: sender)
    }


    @IBAction func onDisplayPopUp(_ sender: UIButton) {
        guard let activeSegmentedControl = activeSegmentedControl else  {
            return
        }

        /// Text only pop ups
        if activeSegmentedControl == textPopUpTypeSegmentedControl {
            switch activeSegmentedControl.selectedSegmentIndex {
                case 0:
                    displayTitleOnlyPopUp()
                case 1:
                    displayBody()
                case 2:
                    displayTitleBodyPopUpWithFade()
                default: break
            }
        }
        /// Spinner pop ups.
        else if activeSegmentedControl == spinnerTypeSegmentedControl {
            switch activeSegmentedControl.selectedSegmentIndex {
                case 0:
                    displaySquareSpinner()
                case 1:
                    displaySquareSpinnerWithTitle()
                case 2:
                    displayStarSpinner()
                default: break
            }
        }
    }

    @IBAction func onHideTap(_ sender: UIButton) {
        guard let popUpView = popUpView else {
            return
        }

        popUpView.hide(completion: nil)
    }

    fileprivate func setActive(segmentedControl: UISegmentedControl) {
        if activeSegmentedControl != segmentedControl {
            inactiveSegmentedControl = activeSegmentedControl
            inactiveSegmentedControl?.selectedSegmentIndex = UISegmentedControlNoSegment
            activeSegmentedControl = segmentedControl
        }
    }
}
