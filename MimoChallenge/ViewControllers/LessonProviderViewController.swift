//
//  LessonProviderViewController.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import UIKit

// Shows the contents of a lesson in a horizontal stack
// - Only supports a single line of contents
// - Can support multiple contents that require user input
class LessonProviderViewController: UIViewController, LessonProvider {
    private struct Constants {
        static let font = UIFont.systemFont(ofSize: 16)
        static let textViewHorizontalPadding = CGFloat(16)
    }
    
    private let lesson: Lesson
    private var allTextFields = [InputCheckingTextField]()
    
    @IBOutlet private var contentStackView: UIStackView!
    
    // MARK: - Lesson Provider
    
    weak var delegate: LessonProviderDelegate? {
        didSet {
            delegate?.lessonIsComplete(allTextFields.isEmpty)
        }
    }
    
    // MARK: - Init
    
    init(lesson: Lesson, delegate: LessonProviderDelegate? = nil) {
        self.lesson = lesson
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lesson.contents.forEach {
            let view = subviewForContent($0)
            if let textField = view as? InputCheckingTextField {
                allTextFields.append(textField)
                textField.delegate = self
            }
            contentStackView.addArrangedSubview(view)
        }
        delegate?.lessonIsComplete(allTextFields.isEmpty)
    }
    
    // MARK: - Subview generation
    
    private func subviewForContent(_ content: LessonContent) -> UIView {
        let view = content.isInput ? textField(from: content) : label(from: content)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        return view
    }
    
    private func textField(from content: LessonContent) -> InputCheckingTextField {
        let textField = InputCheckingTextField(frame: .zero)
        textField.successText = content.text
        textField.font = Constants.font
        textField.textAlignment = .center
        textField.textColor = content.color
        let width = (content.text as NSString).boundingRect(with: CGSize(width: CGFloat.infinity, height: contentStackView.bounds.height), options: .usesLineFragmentOrigin, attributes: [.font: Constants.font], context: nil).width + Constants.textViewHorizontalPadding
        textField.widthAnchor.constraint(equalToConstant: width).isActive = true
        textField.borderStyle = .line
        textField.autocapitalizationType = .none
        return textField
    }
    
    private func label(from content: LessonContent) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = content.text
        label.font = Constants.font
        label.textColor = content.color
        label.textAlignment = .center
        return label
    }
}

extension LessonProviderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? InputCheckingTextField else {
            // TODO: Add debug log
            return true
        }
        guard let delegate = delegate else {
            // TODO: Add debug log
            return true
        }
        guard let textFieldIndex = allTextFields.index(of: textField) else {
            // TODO: Add debug log
            return true
        }
        
        let success: Bool
        defer {
            delegate.lessonIsComplete(success)
        }
        
        let currentText = textField.text ?? ""
        let textAfterReplacement = (currentText as NSString).replacingCharacters(in: range, with: string)
        guard textAfterReplacement == textField.successText else {
            success = false
            return true
        }
        
        var remainingTextFields = allTextFields
        remainingTextFields.remove(at: textFieldIndex)
        success = remainingTextFields.reduce(true) { $0 && $1.text == $1.successText }
        return true
    }
}
