//
//  LessonProvider.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

protocol LessonProvider {
    var lessonViewController: UIViewController { get }
    var delegate: LessonProviderDelegate? { get set }
}

extension LessonProvider where Self: UIViewController {
    var lessonViewController: UIViewController {
        return self
    }
}
