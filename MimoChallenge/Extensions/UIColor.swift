//
//  UIColor.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/19/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

extension UIColor {
    static func newFrom(hexString: String) -> UIColor? {
        var trimmedString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if trimmedString.hasPrefix("#") {
            trimmedString.remove(at: trimmedString.startIndex)
        }
        
        guard trimmedString.count == 6 else {
            return nil
        }
        
        var rgbValue = UInt32(0)
        Scanner(string: trimmedString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
