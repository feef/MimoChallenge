//
//  UIViewAnimationCurve.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/19/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

extension UIViewAnimationCurve {
    var optionsValue: UIViewAnimationOptions {
        return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
    }
}
