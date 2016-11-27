import UIKit

public enum OMAKOSpinnerType {
    case colorChangingSquare
}

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
    open var spinnerSizeInPoints: CGFloat = 20.0
    open var spinnerDuration: TimeInterval = 2.0

    // MARK: - Private variables

    fileprivate var spinnerView: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var bodyLabel: UILabel?

    fileprivate var defaultBackgroundColor: UIColor = UIColor(red: 0.25, green: 0.25, blue: 0.40, alpha: 0.5)

    fileprivate var spinnerType: OMAKOSpinnerType?

    fileprivate var constraintList = [NSLayoutConstraint]()

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

    // MARK: - Public API

    open func display(parentView: UIView) {
        display(parentView: parentView, withDuration: nil, completion: nil)
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

    open func displaySpinner(parentView: UIView, spinnerType: OMAKOSpinnerType = .colorChangingSquare) {
        self.spinnerType = spinnerType

        parentView.addSubview(self)
        animateSpinner()
    }

    open func hide(completion: (() -> Void)?) {
        guard superview != nil else {
            print("Pop up must be part of a view hierarchy.  No superview detected.")
            return
        }

        removeFromSuperview()
        completion?()
    }

    // MARK: - Spinner Animations

    fileprivate func animateSpinner() {
        guard let spinnerType = spinnerType else {
            return
        }

        switch spinnerType {
        case .colorChangingSquare:
            animateColorChangingSquare()
        }
    }

    fileprivate func animateColorChangingSquare() {
        guard let spinnerView = spinnerView, let startingColor = spinnerView.backgroundColor else {
            return
        }

        /// Continuous cycling through colors
        UIView.animateKeyframes(
            withDuration: spinnerDuration,
            delay: 0,
            options: [UIViewKeyframeAnimationOptions.repeat],
            animations: {
                guard let spinnerView = self.spinnerView else {
                    return
                }

                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0/3.0) {
                    spinnerView.backgroundColor = UIColor.green
                }
                UIView.addKeyframe(withRelativeStartTime: 1.0/3.0, relativeDuration: 1.0/3.0) {
                    spinnerView.backgroundColor = UIColor.blue
                }
                UIView.addKeyframe(withRelativeStartTime: 2.0/3.0, relativeDuration: 1.0/3.0) {
                    spinnerView.backgroundColor = startingColor
                }
        },
            completion: nil
        )

        /// Continuous rotation
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = CGFloat(M_PI * 2)
        animation.duration = spinnerDuration
        animation.repeatCount = Float.infinity

        spinnerView.layer.add(animation, forKey: nil)
    }

    // MARK: - Constraint Setup

    fileprivate func setupConstraints() {
        setupSelfConstraints()
        setupSpinnerViewConstraints()

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
                relatedBy: .greaterThanOrEqual,
                toItem: spinnerView,
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
                constant: 0
            )
        )

        centerHorizontallyInParent(subview: titleLabel)
        centerHorizontallyInParent(subview: bodyLabel)

        setupPaddingConstraints()
    }

    fileprivate func setupPaddingConstraints() {
        let orderedSubviews = orderSubviews()

        if let firstViewInPopUp = orderedSubviews.first {
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

        if let lastViewInPopUp = orderedSubviews.last {
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

        for (index, subview) in orderedSubviews.enumerated() {
            if(index > 0) {
                let previousSubview = orderedSubviews[index - 1]
                var topPadding = padding

                /// Put less padding between spinner and
                /// the view below it.
                if let spinnerView = spinnerView {
                    if previousSubview == spinnerView {
                        topPadding = topPadding * 0.75
                    }
                }

                constraintList.append(
                    NSLayoutConstraint(
                        item: subview,
                        attribute: .top,
                        relatedBy: .equal,
                        toItem: previousSubview,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: topPadding
                    )
                )
            }
        }
    }

    fileprivate func orderSubviews() -> [UIView] {
        var orderedSubviews = [UIView]()

        if let spinnerView = spinnerView {
            orderedSubviews.append(spinnerView)
        }

        if let titleLabel = titleLabel {
            orderedSubviews.append(titleLabel)
        }

        if let bodyLabel = bodyLabel {
            orderedSubviews.append(bodyLabel)
        }

        return orderedSubviews
    }

    fileprivate func setupSpinnerViewConstraints() {
        guard let spinnerView = spinnerView else {
            return
        }

        centerHorizontallyInParent(subview: spinnerView)

        /// Width and Height

        constraintList.append(
            NSLayoutConstraint(
                item: spinnerView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: spinnerSizeInPoints
            )
        )

        constraintList.append(
            NSLayoutConstraint(
                item: spinnerView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: spinnerSizeInPoints
            )
        )
    }

    fileprivate func centerHorizontallyInParent(subview: UIView?) {
        guard let subview = subview else {
            return
        }

        constraintList.append(
            NSLayoutConstraint(
                item: subview,
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
        setupSpinnerView()
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

    fileprivate func setupSpinnerView() {
        guard let spinnerType = spinnerType else {
            return
        }

        spinnerView = UIView()

        guard let spinnerView = spinnerView else {
            return
        }

        spinnerView.translatesAutoresizingMaskIntoConstraints = false

        switch spinnerType {
        case .colorChangingSquare:
            setupColorChangingSquareSpinner()
        }

        addSubview(spinnerView)
    }

    fileprivate func setupColorChangingSquareSpinner() {
        guard let spinnerView = spinnerView else {
            return
        }

        spinnerView.backgroundColor = UIColor.red
        spinnerView.layer.cornerRadius = spinnerSizeInPoints / 4
        spinnerView.layer.borderWidth = 2
        spinnerView.layer.borderColor = UIColor.white.cgColor
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
