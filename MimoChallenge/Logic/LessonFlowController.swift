//
//  LessonFlowController.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

// In charge of keeping track of which lesson is currently being shown and showing new ones as appropriate
//  - Currently does not support backtracking through steps, but isn't far from that functionality
class LessonFlowController {
    private let lessons: [Lesson]
    private let navigationController: UINavigationController
    
    private var currentLessonIndex = 0
    private var currentLessonStartDate: Date!
    
    weak var delegate: LessonFlowControllerDelegate?
    
    // MARK: - Init
    
    private init(lessons: [Lesson], navigationController: UINavigationController, delegate: LessonFlowControllerDelegate?) {
        self.lessons = lessons
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    // MARK: - Flow management
    
    // Ideally this could be genericized, but no reason to do
    // that until there's a need for it
    static func showFlow(with lessons: [Lesson], in navigationController: UINavigationController, delegate: LessonFlowControllerDelegate? = nil) throws -> LessonFlowController {
        guard let firstLesson = lessons.first else {
            // TODO: Throw error instead
            fatalError()
        }
        
        let lessonFlowController = LessonFlowController(lessons: lessons, navigationController: navigationController, delegate: delegate)
        lessonFlowController.showLesson(firstLesson)
        return lessonFlowController
    }
    
    // MARK: - Lesson UI updating
    
    fileprivate func showLesson(_ lesson: Lesson, animated: Bool = true) {
        let lessonProviderViewController = LessonProviderViewController(lesson: lesson)
        let lessonContainer = LessonContainerViewController(lessonProviderViewController: lessonProviderViewController, delegate: self)
        currentLessonStartDate = Date()
        navigationController.pushViewController(lessonContainer, animated: animated)
    }
}

extension LessonFlowController: LessonContainerDelegate {
    func lessonContainerViewControllerPressedNextButton(_ lessonContainerViewController: LessonContainerViewController) {
        if delegate == nil {
            // TODO: Add debug log
        }
        
        delegate?.lessonFlowController(self, completedLesson: lessons[currentLessonIndex], withStartDate: currentLessonStartDate, andEndDate: Date())
        
        let nextLessonIndex = currentLessonIndex + 1
        guard nextLessonIndex < lessons.count else {
            delegate?.lessonFlowControllerCompletedAllLessons(self)
            return
        }
        currentLessonIndex = nextLessonIndex
        showLesson(lessons[currentLessonIndex])
    }
}
