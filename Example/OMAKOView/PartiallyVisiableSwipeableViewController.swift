//
//  ViewController.swift
//  OMAKOView
//
//  Created by Kevin Leong on 10/05/2016.
//  Copyright (c) 2016 Kevin Leong. All rights reserved.
//

import UIKit
import OMAKOView

class PartiallyVisibleSwipeableViewController: UIViewController {
    @IBOutlet weak var containerView: OMAKOPartiallyVisibleSwipeableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    let descriptionLoremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

    let titleLoremIpsum = "Qui officia deserunt anim id est laborum."

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Setup

    fileprivate func setupView() {
        /// Make labels multiline and add text
        titleLabel.numberOfLines = 0
        titleLabel.text = titleLoremIpsum
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = descriptionLoremIpsum

        /// Call `setupView(bottomLayoutGuide:)` after the size of the container changes
        containerView.setupView(bottomLayoutGuide: bottomLayoutGuide)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        containerView.onRotate()
    }
}

