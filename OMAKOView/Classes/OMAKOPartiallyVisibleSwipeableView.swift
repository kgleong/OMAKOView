//  OMAKOPartiallyVisibleSwipeableView.swift
//
//  Created by Kevin Leong on 10/4/16.
//  Copyright © 2016 Kevin Leong. All rights reserved.
import UIKit

@IBDesignable
open class OMAKOPartiallyVisibleSwipeableView: UIView {
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
    var isFullyVisible = false
    var verticalPositionConstraint: NSLayoutConstraint?

    // MARK: - View Setup

    /*
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

        - parameters:
          - bottomLayoutGuide: The `bottomLayoutGuide` for the superview.
    */
    open func setupView(bottomLayoutGuide: UILayoutSupport) {
        self.bottomLayoutGuide = bottomLayoutGuide
        setupView()
    }

    /**
        Same as `setupView(bottomLayoutGuide:)`, but uses the superview's bottom
        attribute as a reference to vertically position the view.
    */
    open func setupView() {
        setupConstraints()
        setupGestureRecognizers()
    }

    /**
        Retains the visible state of the view on rotation.

        I.e., if the view is fully visible, this ensures that it
        remains fully visible on rotation.

        The vertical position of the view is based on absolute points,
        and due to the dynamic size of the view, this usually needs to
        be readjusted on any rotation.

        **Usage:**

        ````
        // In a UIViewController:

         override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
            containerView.onRotate()
         }

        ````
    */
    open func onRotate() {
        if(!isFullyVisible) {
            updateVerticalConstraint(displayPercentage: visibleAmount)
        }
        else {
            updateVerticalConstraint(displayPercentage: 1.0)
        }
    }

    // MARK: - Constraints

    fileprivate func setupConstraints() {
        var constraintsList = [NSLayoutConstraint]()

        /// Center within superview if necessary
        if(alignCenter) {
            constraintsList.append(
                NSLayoutConstraint(
                    item: self,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: superview,
                    attribute: .centerX,
                    multiplier: 1,
                    constant: 0
                )
            )
        }

        /// Width constraint
        constraintsList.append(
            NSLayoutConstraint(
                item: self,
                attribute: .width,
                relatedBy: .equal,
                toItem: superview,
                attribute: .width,
                multiplier: relativeWidth,
                constant: 0
            )
        )
        
        NSLayoutConstraint.activate(constraintsList)

        /**
            Layout the view, since concrete bounds values are
            needed for bounds to calculate vertical position
            constraint.
        */
        layoutIfNeeded()

        /// Vertical positioning uses bottom of superview by default.
        var verticalPositionToItem: Any? = superview
        var verticalPositionAttribute = NSLayoutAttribute.bottom

        /// Use the bottom layout guide if specified.
        if let bottomLayoutGuide = bottomLayoutGuide {
            verticalPositionToItem = bottomLayoutGuide
            verticalPositionAttribute = NSLayoutAttribute.top
        }

        verticalPositionConstraint =
            NSLayoutConstraint(
                item: verticalPositionToItem,
                attribute: verticalPositionAttribute,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: verticalConstraintConstant(displayPercentage: visibleAmount)
        )

        NSLayoutConstraint.activate([verticalPositionConstraint!])
    }

    // MARK: - Gestures

    fileprivate func setupGestureRecognizers() {
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeUp))
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up

        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipeDown))
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down

        addGestureRecognizer(swipeUpRecognizer)
        addGestureRecognizer(swipeDownRecognizer)
    }

    @objc fileprivate func onSwipeUp() {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: springSpeed,
            options: [],
            animations: slideUp,
            completion: nil
        )
    }

    @objc fileprivate func onSwipeDown() {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: dampingRatio,
            initialSpringVelocity: springSpeed,
            options: [],
            animations: slideDown,
            completion: nil
        )
    }

    fileprivate func slideDown() {
        updateVerticalConstraint(displayPercentage: visibleAmount)
        isFullyVisible = false
    }

    fileprivate func slideUp() {
        updateVerticalConstraint(displayPercentage: 1.0)
        isFullyVisible = true
    }

    /**
        Uses the superview's `bottomLayoutGuide` as a reference to vertically
        place the view.

        This is the preferred method to use if the superview is the main view
        for the current `UIViewController`.

        - parameters:
            - displayPercentage: Percentage of the view to display.  E.g., 0.1 => 10%
     */
    fileprivate func updateVerticalConstraint(displayPercentage: CGFloat) {
        if let verticalPositionConstraint = verticalPositionConstraint {
            verticalPositionConstraint.constant =
                verticalConstraintConstant(displayPercentage: displayPercentage)

            /// Layout view now that constraints have changed.
            if let parentView = superview {
                /// Required to call on the superview as of Swift 3 upgrade.
                parentView.layoutIfNeeded()
            }
            else {
                layoutIfNeeded()
            }
        }
    }

    fileprivate func verticalConstraintConstant(displayPercentage: CGFloat) -> CGFloat {
        /// Calculates amount of points that should be visible when the
        /// view is partially hidden.
        return bounds.height * displayPercentage
    }
}
