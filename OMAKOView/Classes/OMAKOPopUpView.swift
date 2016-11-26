import UIKit

open class OMAKOPopUpView: UIView {

    // MARK: - Public variables

    /// Text

    open var titleText: NSMutableAttributedString?
    open var bodyText: NSMutableAttributedString?

    open var titleFontName: String?
    open var bodyFontName: String?

    open var titleFontSize: CGFloat = 17.0
    open var bodyFontSize: CGFloat = 15.0

    open var titleFontColor: UIColor = UIColor.red
    open var bodyFontColor: UIColor = UIColor.green

    /// Layout

    open var padding: CGFloat = 10.0
    open var cornerRadius: CGFloat? = 10.0

    // MARK: - Private variables

    fileprivate var titleLabel: UILabel?
    fileprivate var bodyLabel: UILabel?
    fileprivate var spinner: UIView?

    fileprivate var defaultBackgroundColor: UIColor = UIColor(red: 0.25, green: 0.25, blue: 0.40, alpha: 0.5)

    fileprivate var showSpinner: Bool = false
    fileprivate var constraintList = [NSLayoutConstraint]()

    // MARK: - Public API

    open func display(parentView: UIView, withDuration duration: TimeInterval?, completion: (() -> Void)?) {
        parentView.addSubview(self)
        parentView.bringSubview(toFront: self)

        guard let duration = duration else {
            return
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { (Boolean) -> Void
            in

            guard let completion = completion else {
                return
            }

            /// All constraints must be deactivated before removing a view
            NSLayoutConstraint.deactivate(self.constraintList)
            self.removeFromSuperview()

            completion()
        })
    }

    open func hide(onCompletion: (() -> Void)?) {
        guard let parentView = superview else {
            print("Pop up must be part of a view hierarchy.  No superview detected.")
            return
        }
    }

    // MARK: - UIView Methods

    override open func didMoveToSuperview() {
        setupView()
        setupConstraints()
    }

    // MARK: - Constraint Setup

    fileprivate func setupConstraints() {
        setupSelfConstraints()
        setupTitleLabelConstraints()

        NSLayoutConstraint.activate(constraintList)
    }

    fileprivate func setupSelfConstraints() {
        /// Horizontal and vertical centering

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: superview,
                attribute: .centerX,
                multiplier: 1,
                constant: 0)
        )

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: superview,
                attribute: .centerY,
                multiplier: 1,
                constant: 0)
        )

        /// Width relative to contents

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .greaterThanOrEqual,
                toItem: titleLabel,
                attribute: .width,
                multiplier: 1,
                constant: padding * 2
            )
        )
    }

    fileprivate func setupTitleLabelConstraints() {
        /// Padding

        constraintList.append(
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: padding)
        )

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: titleLabel,
                attribute: .bottom,
                multiplier: 1,
                constant: padding
            )
        )

        /// Horizontal centering

        constraintList.append(
            NSLayoutConstraint(
                item: titleLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1,
                constant: 0
            )
        )
    }


    // MARK: - View Setup

    fileprivate func setupView() {
        setupSelfView()
        setupTitleLabel()
        setupBodyLabel()
    }

    fileprivate func setupSelfView() {
        translatesAutoresizingMaskIntoConstraints = false

        if backgroundColor == nil {
            self.backgroundColor = defaultBackgroundColor
        }

        if let cornerRadius = cornerRadius {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
        }

    }

    fileprivate func setupTitleLabel() {
        titleLabel = createLabel(
            attributedText: titleText,
            fontName: titleFontName,
            fontSize: titleFontSize,
            fontColor: titleFontColor,
            boldByDefault: true
        )

        guard let titleLabel = titleLabel else {
            return
        }

        addSubview(titleLabel)
    }

    fileprivate func createLabel(
            attributedText: NSMutableAttributedString?,
            fontName: String?,
            fontSize: CGFloat,
            fontColor: UIColor,
            boldByDefault: Bool = false
        ) -> UILabel? {

        guard let attributedText = attributedText else {
            return nil
        }

        var font: UIFont?

        if let fontName = fontName {
            font = UIFont(name: fontName, size: fontSize)
        }
        else if boldByDefault {
            font = UIFont.boldSystemFont(ofSize: fontSize)
        }
        else {
            font = UIFont.systemFont(ofSize: fontSize)
        }

        var fullRange: NSRange = NSMakeRange(0, attributedText.length)

        attributedText.addAttribute(NSFontAttributeName, value: font, range: fullRange)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: defaultParagraphStyle(), range: fullRange)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: titleFontColor, range: fullRange)

        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = attributedText

        return label
    }

    fileprivate func setupBodyLabel() {
        guard let bodyText = bodyText else {
            return
        }
    }

    fileprivate func defaultParagraphStyle() -> NSMutableParagraphStyle {
        var paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        return paragraphStyle
    }
}
