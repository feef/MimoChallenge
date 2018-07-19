//
//  UIViewController.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

extension UIViewController {
    func addContainedViewController(_ containedViewController: UIViewController, inView view: UIView) {
        guard containedViewController.parent == nil else {
            //TODO: Add debug log
            return
        }
        let containedView: UIView = containedViewController.view
        addChildViewController(containedViewController)
        containedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containedView)
        containedView.addFitToParentContraints()
        containedViewController.didMove(toParentViewController: self)
    }
    
    func removeContainedViewController(_ containedViewController: UIViewController) {
        guard containedViewController.parent != nil else {
            return
        }
        containedViewController.willMove(toParentViewController: nil)
        containedViewController.view.removeFromSuperview()
        containedViewController.removeFromParentViewController()
    }
}
