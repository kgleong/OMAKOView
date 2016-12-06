import UIKit
import OMAKOView

class StarViewController: UIViewController {
    @IBOutlet weak var strokeAndFillButton: UIButton!
    @IBOutlet weak var fillOnlyButton: UIButton!
    @IBOutlet weak var withBackgroundButton: UIButton!
    @IBOutlet weak var thickButton: UIButton!
    @IBOutlet weak var thinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onButtonTap(_ sender: UIButton) {
        print("tapped")
    }
}
