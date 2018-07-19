//
//  LessonSession.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/19/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import Foundation
import RealmSwift

class LessonSession: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var lessonID: Lesson.ID = -1
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
