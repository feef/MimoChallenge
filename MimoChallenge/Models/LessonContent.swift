//
//  LessonContent.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit
import SwiftyJSON

struct LessonContent {
    var color: UIColor
    let text: String
    var isInput: Bool
    
    init?(color: UIColor, text: String, isInput: Bool = false) {
        guard !text.isEmpty else {
            return nil
        }
        self.color = color
        self.text = text
        self.isInput = isInput
    }
    
    static func dummy() -> LessonContent {
        let colors: [UIColor] = [.red, .blue, .black, .purple]
        let colorIndex = Int(arc4random()) % colors.count
        return LessonContent(color: colors[colorIndex], text: "text", isInput: arc4random() % 2 == 0)!
    }
}

extension LessonContent: JSONInitializable {
    init?(json: JSON) {
        guard
            let colorString = json["color"].string,
            let color = UIColor.newFrom(hexString: colorString),
            let text = json["text"].string
        else {
            return nil
        }
        self.init(color: color, text: text)
    }
}
