//
//  LessonFlowStatusViewController.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit
import RealmSwift

class LessonFlowStatusViewController: UIViewController {
    @IBOutlet private var startFlowButton: UIButton!
    @IBOutlet private var successLabel: UILabel!
    
    private var lessons = [Lesson]()
    private var flowController: LessonFlowController?
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchOperation = LessonGroupFetchOperation() { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
                case .failure:
                    // TODO: Show something, retry, anything
                    return
                case .success(let lessons):
                    strongSelf.lessons = lessons
                    DispatchQueue.main.async {
                        strongSelf.startFlowButton.setTitle("Start lessons", for: .normal)
                        strongSelf.startFlowButton.isEnabled = true
                    }
            }
        }
        OperationQueue.main.addOperation(fetchOperation)
    }
    
    // MARK: - Button response
    
    @IBAction private func startFlowButtonPressed() {
        guard let navigationController = navigationController else {
            // TODO: Add debug log
            return
        }
        do {
            flowController = try LessonFlowController.showFlow(with: lessons, in: navigationController, delegate: self)
        } catch {
            // TODO: Add debug log
        }
    }
}

extension LessonFlowStatusViewController: LessonFlowControllerDelegate {
    func lessonFlowController(_ lessonFlowController: LessonFlowController, completedLesson lesson: Lesson, withStartDate startDate: Date, andEndDate endDate: Date) {
        let database = try! Realm()
        
        let session = LessonSession()
        session.startDate = startDate
        session.endDate = endDate
        session.lessonID = lesson.id
        
        try! database.write {
            database.add(session)
        }
    }
    
    func lessonFlowControllerCompletedAllLessons(_ lessonFlowController: LessonFlowController) {
        flowController = nil
        navigationController?.popToViewController(self, animated: true)
        successLabel.isHidden = false
        startFlowButton.setTitle("Go again!", for: .normal)
    }
}
