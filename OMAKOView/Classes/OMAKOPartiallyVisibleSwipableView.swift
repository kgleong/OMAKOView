//  OMAKOPartiallyVisibleSwipableView.swift
//
//  Created by Kevin Leong on 10/4/16.
//  Copyright © 2016 Kevin Leong. All rights reserved.
import UIKit

@IBDesignable
public class OMAKOPartiallyVisibleSwipableView: UIView {
    /// Positioning
    @IBInspectable var visibleAmount: CGFloat = 0.4

    /// Dimensions
    @IBInspectable var relativeWidth: CGFloat = 0.75

    /// Animation properties
    @IBInspectable var duration: Double = 1.5
    @IBInspectable var dampingRatio: CGFloat = 0.5
    @IBInspectable var springSpeed: CGFloat = 0.5
    @IBInspectable var alignCenter: Bool = true

    var bottomLayoutGuide: UILayoutSupport?
    var verticalPositionConstraint: NSLayoutConstraint?

    /**
        Standard Initializer

        - Parameter frame: The view's bounding frame.
    */
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    /**
        Required initializer for Interface Builder objects.
    */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - View Setup

    /**
        View setup functions must be called after initialization.
        E.g., `viewDidLoad`.

        The `verticalPositionConstraint` assumes that the view has been laid
        out and the view now has concrete measurements.

        If content is added dynamically to subviews, e.g., text is assigned
        to a label, call `setupView()` or `setupView(bottomLayoutGuide:)` after
        all subview content has been set.
    */

    /**
        Uses the superview's `bottomLayoutGuide` as a reference to vertically
        place the view.

        This is the preferred method to use if the superview is the main view
        for the current `UIViewController`.

        - Parameter bottomLayoutGuide: The `bottomLayoutGuide` for the superview.
    */
    public func setupView(bottomLayoutGuide bottomLayoutGuide: UILayoutSupport) {
        self.bottomLayoutGuide = bottomLayoutGuide
        setupView()
    }

    /**
        Same as `setupView(bottomLayoutGuide:)`, but uses the superview's bottom
        attribute as a reference to vertically position the view.
    */
    public func setupView() {
        setupConstraints()
        setupGestureRecognizers()
    }

    // MARK: - Constraints

    private func setupConstraints() {
        var constraintsList = [NSLayoutConstraint]()

        /// Center within superview if necessary
        if(alignCenter) {
            constraintsList.append(
                NSLayoutConstraint(
                    item: self,
                    attribute: .CenterX,
                    relatedBy: .Equal,
                    toItem: superview,
                    attribute: .CenterX,
                    multiplier: 1,
                    constant: 0
                )
            )
        }

        /// Width constraint
        constraintsList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: superview,
                attribute: .Width,
                multiplier: relativeWidth,
                constant: 0
            )
        )

        NSLayoutConstraint.activateConstraints(constraintsList)

        /**
            Layout the view, since concrete bounds values are
            needed for bounds to calculate vertical position
            constraint.
        */
        layoutIfNeeded()

        /// Vertical positioning uses bottom of superview by default.
        var verticalPositionToItem: AnyObject? = superview
        var verticalPositionAttribute = NSLayoutAttribute.Bottom

        /// Use the bottom layout guide if specified.
        if let unwrappedBottomLayoutGuide = bottomLayoutGuide {
            verticalPositionToItem = unwrappedBottomLayoutGuide
            verticalPositionAttribute = NSLayoutAttribute.Top
        }

        verticalPositionConstraint =
            NSLayoutConstraint(
                item: self,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: verticalPositionToItem,
                attribute: verticalPositionAttribute,
                multiplier: 1,
                constant: verticalConstraintConstant(self.visibleAmount)
        )

        NSLayoutConstraint.activateConstraints([verticalPositionConstraint!])
    }

    // MARK: - Gestures

    private func setupGestureRecognizers() {
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUp))
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.Up

        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.Down

        addGestureRecognizer(swipeUpRecognizer)
        addGestureRecognizer(swipeDownRecognizer)
    }

    @objc private func onSwipeUp() {
        UIView.animateWithDuration(
            duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: springSpeed,
            options: [],
            animations: slideUp,
            completion: nil
        )
    }

    @objc private func onSwipeDown() {
        UIView.animateWithDuration(
            duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: springSpeed,
            options: [],
            animations: slideDown,
            completion: nil
        )
    }

    private func slideDown() {
        updateVerticalConstraint(self.visibleAmount)
    }

    private func slideUp() {
        updateVerticalConstraint(1.0)
    }

    private func updateVerticalConstraint(visibleAmount: CGFloat) {
        verticalPositionConstraint!.constant = verticalConstraintConstant(visibleAmount)

        /// Layout view now that constraints have changed.
        layoutIfNeeded()
    }

    private func verticalConstraintConstant(visibleAmount: CGFloat) -> CGFloat {
        return -1 * bounds.height * visibleAmount
    }
}
