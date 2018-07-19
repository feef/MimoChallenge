//
//  LessonFlowControllerDelegate.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import Foundation

protocol LessonFlowControllerDelegate: class {
    func lessonFlowController(_ lessonFlowController: LessonFlowController, completedLesson lesson: Lesson, withStartDate startDate: Date, andEndDate endDate: Date)
    func lessonFlowControllerCompletedAllLessons(_ lessonFlowController: LessonFlowController)
}
