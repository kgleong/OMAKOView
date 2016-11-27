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

    open var titleFontColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
    open var bodyFontColor: UIColor = UIColor(red: 0.3, green: 0.1, blue: 0.3, alpha: 1.0)

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

    open func display(parentView: UIView, completion: (() -> Void)?) {
        display(parentView: parentView, withDuration: nil, completion: completion)
    }

    open func display(parentView: UIView, withDuration duration: TimeInterval?, completion: (() -> Void)?) {
        parentView.addSubview(self)
        parentView.bringSubview(toFront: self)

        guard let duration = duration else {
            completion?()
            return
        }

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }, completion: { (Boolean) -> Void
            in
            
            self.removeFromSuperview()

            guard let completion = completion else {
                return
            }

            completion()
        })
    }

    open func hide(completion: (() -> Void)?) {
        guard superview != nil else {
            print("Pop up must be part of a view hierarchy.  No superview detected.")
            return
        }

        removeFromSuperview()
        completion?()
    }

    // MARK: - UIView Methods

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()

        /*
            `didMoveToSuperview` and `willMoveToSuperview` are called
            by `removeFromSuperview`, which calls `willMove(toSuperview: nil)`.
         
            `nil` check prevents re-creating constraints and views when
            the pop up is removed from its parent view.
        */
        if superview != nil {
            setupView()
            setupConstraints()
        }
    }

    // MARK: - Constraint Setup

    fileprivate func setupConstraints() {
        setupSelfConstraints()
        setupTitleLabelConstraints()
        setupBodyLabelConstraints()

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

        /// Width

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

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .greaterThanOrEqual,
                toItem: bodyLabel,
                attribute: .width,
                multiplier: 1,
                constant: padding * 2
            )
        )

        constraintList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .lessThanOrEqual,
                toItem: superview,
                attribute: .width,
                multiplier: 0.5,
                constant: 0            )
        )

        /// Top and bottom padding

        if let firstViewInPopUp = firstViewInPopUp() {
            constraintList.append(
                NSLayoutConstraint(
                    item: firstViewInPopUp,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .top,
                    multiplier: 1,
                    constant: padding)
            )
        }

        if let lastViewInPopUp = lastViewInPopUp() {
            constraintList.append(
                NSLayoutConstraint(
                    item: self,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: lastViewInPopUp,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: padding
                )
            )
        }
    }

    fileprivate func firstViewInPopUp() -> UIView? {
        if titleLabel != nil {
            return titleLabel
        }
        else if bodyLabel != nil {
            return bodyLabel
        }
        else {
            return nil
        }
    }


    fileprivate func lastViewInPopUp() -> UIView? {
        if bodyLabel != nil {
            return bodyLabel
        }
        else if titleLabel != nil {
            return titleLabel
        }
        else {
            return nil
        }
    }

    fileprivate func setupTitleLabelConstraints() {
        guard let titleLabel = titleLabel else {
            return
        }

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

    fileprivate func setupBodyLabelConstraints() {
        guard let bodyLabel = bodyLabel else {
            return
        }

        /// Vertical positioning if title label exists

        if let titleLabel = titleLabel {
            constraintList.append(
                NSLayoutConstraint(
                    item: bodyLabel,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: titleLabel,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: padding
                )
            )
        }

        /// Horizontal centering

        constraintList.append(
            NSLayoutConstraint(
                item: bodyLabel,
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

        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
    }

    fileprivate func setupBodyLabel() {
        bodyLabel = createLabel(
            attributedText: bodyText,
            fontName: bodyFontName,
            fontSize: bodyFontSize,
            fontColor: bodyFontColor,
            boldByDefault: false
        )

        guard let bodyLabel = bodyLabel else {
            return
        }

        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bodyLabel)
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

        let fullRange: NSRange = NSMakeRange(0, attributedText.length)

        attributedText.addAttribute(NSFontAttributeName, value: font!, range: fullRange)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: defaultParagraphStyle(), range: fullRange)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: fullRange)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = attributedText

        return label
    }

    fileprivate func defaultParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        return paragraphStyle
    }
}
