import UIKit

open class OMAKOPopUpView: UIView {

    // MARK: - Public variables

    /// Text

    open var titleText: NSMutableAttributedString?
    open var bodyText: NSMutableAttributedString?

    open var titleFontName: String?
    open var bodyFontName: String?

    open var titleFontSize: CGFloat = 18.0
    open var bodyFontSize: CGFloat = 15.0

    /// Layout

    open var padding: CGFloat = 10.0

    // MARK: - Private variables

    fileprivate var titleLabel: UILabel?
    fileprivate var bodyLabel: UILabel?
    fileprivate var spinner: UIView?

    fileprivate var showSpinner: Bool = false

    fileprivate var defaultBackgroundColor: UIColor = UIColor(red: 0.25, green: 0.25, blue: 0.40, alpha: 0.75)

    // MARK: - Public API

    open func display(parentView: UIView, withDuration duration: TimeInterval?, completion: (() -> Void)?) {
        parentView.addSubview(self)
        parentView.bringSubview(toFront: self)

        guard let duration = duration else {
            return
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: {
            removeFromSuperview()

            guard let completion = completion else {
                return
            }

            completion()
        })
    }

    open func hide(@escaping onCompletion: (() -> Void)?) {
        guard let parentView = superview else {
            print("Pop up must be part of a view hierarchy.  No superview detected")
            return
        }
    }

    // MARK: - UIView Methods

    override func didMoveToSuperview() {
        setupView()
        setupConstraints()
    }

    // MARK: - View Setup

    fileprivate func setupView() {
        setupSelfView()
        setupTitleLabel()
        setupBodyLabel()
    }

    fileprivate func setupSelfView() {
        if backgroundColor == nil {
            self.backgroundColor = defaultBackgroundColor
        }
    }

    fileprivate func setupTitleLabel() {
        guard let titleText = titleText else {
            return
        }

        var font: UIFont =
            let titleFontName = titleFontName {
                UIFont(name: titleFontName, size: titleFontSize)
            }
            else {
                UIFont.boldSystemFont(ofSize: titleFontSize)
            }

        var fullRange: NSRange = NSMakeRange(0, titleText.length)

        titleText.addAttribute(NSFontAttributeName, value: font, range: fullRange)
        titleText.addAttribute(NSParagraphStyleAttributeName, value: defaultParagraphStyle(), range: fullRange)

        titleLabel = UILabel()
        titleLabel?.text = titleText
    }

    fileprivate func setupBodyLabel() {
        guard let bodyText = bodyText else {
            return
        }
    }

    fileprivate func defaultParagraphStyle() -> NSMutableParagraphStyle {
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
    }

    // MARK: - Constraint Setup

    fileprivate func setupConstraints() {

    }
}
