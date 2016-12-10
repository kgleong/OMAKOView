# OMAKOView

[![Version](https://img.shields.io/cocoapods/v/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![License](https://img.shields.io/cocoapods/l/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![Platform](https://img.shields.io/cocoapods/p/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/kgleong/omakoview)](http://clayallsopp.github.io/readme-score?url=https://github.com/kgleong/omakoview)

|Description|Specification|
|----|-----------|
|Language| Swift 3|

## Overview

Custom views included in this library:

|Name|Description|
|----|-----------|
|[Pop Up View & Loading Spinner](#pop-up-view)|A pop up that shows a title and/or caption in addition to a loading spinner.|
|[Star View](#star-view)|Highly configurable `UIView` star drawn using `UIBezierPath` objects.|
|[Partially visible swipeable view](#partially-visible-swipeable-view)|A partially visible view that responds to vertical swipes to reveal and hide its content.|

### Table of Contents

* [PopUpView](#pop-up-view)
* [Star View](#star-view)
* [Partially visible swipeable view](#partially-visible-swipeable-view)

## Pop Up View

Customizable pop up that can fade away after a specified interval and also takes a closure that is called on dismissal or completion.

![Pop up view demo](/images/popup-view-demo.gif)

### Configuration

|Property Name|Description|Type|Default|
|-------------|-----------|----|-------|
|`titleText`|Styleable title text|`NSMutableAttributedString`|N/A|
|`bodyText`|Styleable body text|`NSMutableAttributedString`|N/A|
|`titleFontName`|Title font name. Passed into `UIFont(name:size:)`|`String`|`nil`.  Will default to system font.|
|`bodyFontName`|Body font name. Passed into `UIFont(name:size:)`|`String`|`nil`.  Will default to system font.|
|`titleFontColor`|Tile font color|`UIColor`|Dark blue|
|`bodyFontColor`|Body font color|`UIColor`|Purple|
|`spinnerBorderColor`|Spinner border color|`UIColor`|Off white|
|`spinnerFillColor`|Used for spinners which retain the same color.|`UIColor`|Powder blue|
|`spinnerBorderWidth`|The border width of the spinner.|`CGFloat`|5.0|
|`padding`|The padding between the elements.  E.g., spinner, title, body.|`CGFloat`|10.0|
|`cornerRadius`|If set, will clip the view and round the edges to the specified value.|`CGFloat`|10.0|
|`spinnerSizeInPoints`|The size of the spinner view.|`CGFloat`|20.0|
|`spinnerDuration`|The duration of the rotation and any other spinner animations.|`CGFloast`|2.0|

### Usage

#### Text only

Display a standard pop up with a title and body.

```swift
popUpView = OMAKOPopUpView()

popUpView.titleText = NSMutableAttributedString(string: "Title")
popUpView.bodyText = NSMutableAttributedString(string: "Body")

// Pass in the view that the popup should be centered in.
// The pop up will add itself to the view's hierarchy.
popUpView.display(parentView: view)
```

Hiding a popup:
```swift
popUpView.hide(completion: nil)

// Or a completion block can be passed in:
popUpView.hide() { print("Do something after the popup is dismissed") }
```

Displaying a popup for a set interval:

```swift
/*
    Will dismiss the popup after 5 seconds.

    A completion block can be passed in, which will execute after the popup
    is dismissed.
*/
popUpView.display(parentView: view, withDuration: 5.0, completion: nil)
```

#### Spinners

```swift
popUpView = OMAKOPopUpView()

popUpView.titleText = NSMutableAttributedString(string: "Loading")
popUpView.spinnerSizeInPoints = 40.0 // Results in a larger spinner.

popUpView.displaySpinner(parentView: view, spinnerType: .square) // Square spinner
popUpView.displaySpinner(parentView: view, spinnerType: .star) // Star spinner

// Hide
popUpView.hide(completion: nil)
```

## Star View

A `UIView` that draws a highly configurable star using `UIBezierPath` objects.

![Star view demo](/images/star-view-demo.gif)

### Configuration

In Interface Builder, the following properties are available:

![Star view inspectable properties](/images/star-inspectable.png)

|Property Name|Description|Type|Default|
|-------------|-----------|----|-------|
|`strokeWidth`|The star's border width.|`CGFloat`|`5.0`|
|`hasStroke`|If true, a border will be rendered.|`Bool`|`false`|
|`strokeColor`|Border color.|`UIColor`|Red|
|`fillColor`|The star's fill color.|`UIColor`|Powder blue|
|`innerToOuterRadiusRatio`|Determines the thickness of the star.  Values closer to 1.0 will widen the arms of the star, while values closer to 0.0 will thin the arms.|`CGFloat`|`0.45`|
|`starToViewRatio`|The size of the star proportional to the view.  Range: 0.0 to 1.0.|`CGFloat`|`1.0`|
|`cacheVertices`|Vertex positions will be cached.  Set this to false if vertex positions are expected to change between `draw(_:)` render calls.|`Bool`|`true`|

### Usage

![Star view variations](/images/star_variations.png)

```swift
var starView = OMAKOStarView()
starView.hasStroke = true
starView.strokeWidth = 5.0
starView.strokeColor = UIColor.red
starView.fillColor = UIColor.yellow
starView.innerToOuterRadiusRatio = 0.25 // Results in a thinner star.
starView.starToViewRatio = 0.8 // Results in a smaller star.
```

Rounding the edges inscribes the star within a circle, since the view is a subclass of `UIView`.

```swift
var starView = OMAKOStarView()

// Creates a circular border. The usual UIView properties are available.
starView.layer.cornerRadius = starView.bounds.width/Float(2)
starView.layer.borderWidth = 5.0
starView.layer.borderColor = UIColor.red.cgColor
starView.clipToBound = true
```

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
|**spring speed**|`CGFloat`| The spring's initial velocity. The damping ratio will proportionally decrement this value until the velocity reaches 0.|Higher values will increase the oscillations' speed. Default is set to `0.5`.|

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
