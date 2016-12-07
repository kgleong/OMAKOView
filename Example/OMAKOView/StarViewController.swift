import UIKit
import OMAKOView

class StarViewController: UIViewController {
    @IBOutlet weak var strokeAndFillButton: UIButton!
    @IBOutlet weak var fillOnlyButton: UIButton!
    @IBOutlet weak var withBackgroundButton: UIButton!
    @IBOutlet weak var thickButton: UIButton!
    @IBOutlet weak var thinButton: UIButton!

    @IBOutlet weak var starView: OMAKOStarView!

    fileprivate let defaultInnerOuterRadiusRatio: CGFloat = 0.45

    override func viewDidLoad() {
        super.viewDidLoad()

        onStrokeAndFillTap() // Default
    }

    // MARK: - Button Actions

    fileprivate func onStrokeAndFillTap() {
        setCommonStarConfig()
        setDefaultFillAndStroke()
    }

    fileprivate func onFillOnlyTap() {
        setCommonStarConfig()

        starView.fillColor = UIColor(red: 0.05, green: 0.5, blue: 1.0, alpha: 1.0)
        starView.hasStroke = false
    }

    fileprivate func onBackgroundTap() {
        setCommonStarConfig()

        let redColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 1.0)
        starView.strokeWidth = 20
        starView.strokeColor = redColor
        starView.hasStroke = true
        starView.fillColor = UIColor(red: 0.95, green: 0.95, blue: 0.99, alpha: 1.0)

        starView.backgroundColor = UIColor(red: 0.12, green: 0.46, blue: 0.24, alpha: 1.0)
        starView.layer.cornerRadius = 75
        starView.clipsToBounds = true
        starView.layer.borderColor = redColor.cgColor
        starView.layer.borderWidth = 10

        starView.starToViewRatio = 0.77
    }

    fileprivate func onThickStarTap() {
        setCommonStarConfig()
        setDefaultFillAndStroke()
        starView.innerToOuterRadiusRatio = 0.6
    }

    fileprivate func onThinStarTap() {
        setCommonStarConfig()
        setDefaultFillAndStroke()
        starView.innerToOuterRadiusRatio = 0.3
    }

    // MARK: - Common view configuration

    fileprivate func setCommonStarConfig() {
        starView.cacheVertices = false
        starView.innerToOuterRadiusRatio = defaultInnerOuterRadiusRatio
        starView.starToViewRatio = 1.0
        starView.backgroundColor = UIColor.clear
        starView.layer.borderColor = nil
        starView.layer.borderWidth = 0
    }

    fileprivate func setDefaultFillAndStroke() {
        starView.strokeWidth = 20
        starView.strokeColor = UIColor.red
        starView.hasStroke = true
        starView.fillColor = UIColor.yellow
    }

    // MARK: - Target actions

    @IBAction func onButtonTap(_ sender: UIButton) {
        if sender == strokeAndFillButton {
            onStrokeAndFillTap()
        }
        else if sender == fillOnlyButton {
            onFillOnlyTap()
        }
        else if sender == withBackgroundButton {
            onBackgroundTap()
        }
        else if sender == thickButton {
            onThickStarTap()
        }
        else if sender == thinButton {
            onThinStarTap()
        }
        starView.setNeedsDisplay()
    }
}
