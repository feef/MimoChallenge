//
//  LessonContainerViewController.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

class LessonContainerViewController: UIViewController {
    private let lessonProviderViewController: LessonProviderViewController
    
    @IBOutlet fileprivate var nextButton: UIButton!
    @IBOutlet private var lessonContentContainerView: UIView!
    @IBOutlet private var nextButtonBottomConstraint: NSLayoutConstraint!
    
    private var keyboardManager: KeyboardManager!
    
    weak var delegate: LessonContainerDelegate?
    
    // MARK: - Init
    
    init(lessonProviderViewController: LessonProviderViewController, delegate: LessonContainerDelegate) {
        self.lessonProviderViewController = lessonProviderViewController
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
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
        keyboardManager = KeyboardManager(onAnyChange: { [weak self] keyboardFrame in
            guard let strongSelf = self else {
                return
            }
            let overlappingFrame = keyboardFrame.intersection(strongSelf.view.frame)
            strongSelf.nextButtonBottomConstraint.constant = overlappingFrame.height
            strongSelf.view.layoutIfNeeded()
        })
        lessonProviderViewController.delegate = self
        addContainedViewController(lessonProviderViewController, inView: lessonContentContainerView)
    }
    
    // MARK: - Actions
    
    @IBAction private func pressedNextButton() {
        guard let delegate = delegate else {
            // TODO: Add debug log
            return
        }
        delegate.lessonContainerViewControllerPressedNextButton(self)
    }
}

extension LessonContainerViewController: LessonProviderDelegate {
    func lessonIsComplete(_ complete: Bool) {
        guard nextButton.isEnabled != complete else {
            return
        }
        nextButton.isEnabled = complete
    }
}
