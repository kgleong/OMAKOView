# OMAKOView

[![CI Status](http://img.shields.io/travis/kgleong/OMAKOView.svg?style=flat)](https://travis-ci.org/kgleong/OMAKOView)
[![Version](https://img.shields.io/cocoapods/v/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![License](https://img.shields.io/cocoapods/l/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![Platform](https://img.shields.io/cocoapods/p/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/kgleong/omakoview)](http://clayallsopp.github.io/readme-score?url=https://github.com/kgleong/omakoview)

## Overview

Custom views included in this library:

|Name|Description|
|----|-----------|
|[Partially visible swipeable view](#partially-visible-swipeable-view)|A partially visible view that responds to vertical swipes to reveal and hide its content.|

## Partially Visible Swipeable View

![Partially Visible Swipeable View demo](/images/partially-visible-swipeable-demo-1.gif)

### Usage

#### Important Note on Constraints

**A width constraint for the view must be set if using Interface Builder.**

The `remove at build time` placeholder checkbox **MUST BE** selected for the width constraint.

Interface builder autogenerates constraints, and this will result in constraint conflicts if the above steps are not followed.

The same needs to be done for **height** if the height of the view is dynamic.  E.g., multiline labels that contain dynamic text.

#### `UIViewController` Example

```swift
class ViewController: UIViewController {
    @IBOutlet weak var containerView: OMAKOPartiallyVisibleSwipeableView!
    @IBOutlet weak var titleLabel: UILabel!

    let titleLoremIpsum = "Qui officia deserunt anim id est laborum."

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make labels multiline and add text
        titleLabel.numberOfLines = 0
        titleLabel.text = titleLoremIpsum

        /*
            `setupView(bottomLayoutGuide:)` should be called after any
            changes are made to subviews that may affect the size of the
            `containerView`.  E.g., Dynamically setting multiline label text.

            Optionally, `setupView()` can be called without paramters and this
            will by default pin the view to the bottom of the superview.

           Pinning the view to the `bottomLayoutGuide`, however, is preferred.
        */
        containerView.setupView(bottomLayoutGuide: bottomLayoutGuide)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        // Must be called on device orientation changes.
        // Screen rotations will change the height of the `container view`,
        // and `onRotate()` accounts for any changes.
        containerView.onRotate()
    }
}
```

### IBInspectable Properties

![Partially Visible Swipeable IBInspectable properties](/images/partially-visible-swipeable-ib-inspectable.png)

|Name|Type|Description|Values|
|----|----|-----------|------|
|**visible amount**|`CGFloat`|Proportion of the view's height that should be initially visible.|A value of `1.0` is fully visible, and `0.0` is completely hidden. Default value is `0.4`, which makes 40% of the view's height visible.|
|**relative width**|`CGFloat`|Width of the view relative to its superview.|`1.0` matches the width of the parent, and `0.0` gives the view a width of 0.  Default is `0.75` or three-quarters of the superview's width |
|**align center**|`Boolean`|Centers the view within the superview.|Default set to `true`.|

The properties below adjust the animation oscillation and bounce .  See the Apple developer documentation on [`animateWithDuration ` with spring damping](https://developer.apple.com/reference/uikit/uiview/1622594-animatewithduration?language=objc) for more details.

|Name|Type|Description|Values|
|----|----|-----------|------|
|**duration**|`CGFloat`|How long the animation should take, in seconds.|If `<= 0`, no animation will be applied.  Default is set to `1.5` seconds|
|**damping ratio**|`CGFloat`| Amount of bouncing desired.|Use `1` to smoothly decelerate with no oscillation.  Values closer to `0` will increase oscillation/bouncing. The higher the value, the faster the oscillations will cease. Default is set to `0.5`.|
|**spring speed**|`CGFloat`| The spring's initial velocity. The damping ratio will proportionally decrement this value until the velocity reaches 0.|Higher values will increase the oscillations speed. Default is set to `0.5`.|

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

OMAKOView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "OMAKOView"
```

## Author

Kevin Leong, kgleong@gmail.com

## License

OMAKOView is available under the MIT license. See the LICENSE file for more info.
