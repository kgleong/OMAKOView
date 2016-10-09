# OMAKOView

[![CI Status](http://img.shields.io/travis/kgleong/OMAKOView.svg?style=flat)](https://travis-ci.org/kgleong/OMAKOView)
[![Version](https://img.shields.io/cocoapods/v/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![License](https://img.shields.io/cocoapods/l/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)
[![Platform](https://img.shields.io/cocoapods/p/OMAKOView.svg?style=flat)](http://cocoapods.org/pods/OMAKOView)

## Overview

Custom views included in this library:

|Name|Description|
|----|-----------|
|[Partially visible swipeable view](#partially-visible-swipeable-view)|A partially visible view that responds to vertical swipes to reveal and hide it's content.|

## Partially Visible Swipeable View

![Partially Visible Swipeable View demo](/images/partially-visible-swipeable-demo-1.png)

### Usage

```swift
class ViewController: UIViewController {
    @IBOutlet weak var containerView: OMAKOPartiallyVisibleSwipeableView!
    @IBOutlet weak var titleLabel: UILabel!

    let titleLoremIpsum = "Qui officia deserunt anim id est laborum."

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Make labels multiline and add text
        titleLabel.numberOfLines = 0
        titleLabel.text = titleLoremIpsum

        // `setupView(bottomLayoutGuide:)` should be called after any
        // changes are made to subviews that may affect the size of the
        // `containerView`.  E.g., Dynamically setting multiline label text.
        containerView.setupView(bottomLayoutGuide: bottomLayoutGuide)
    }

    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        containerView.onRotate()
    }
}
```

### IBInspectable Properties
|Name|Type|Description|
|----|----|-----------|
|**visible amount**|`CGFloat`||
|**relative width**|`CGFloat`||
|**duration**|`Double`||
|**damping ratio**|`GCFloat`||
|**spring speed**|`CGFloat`||
|**align center**|`Boolean`||

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
