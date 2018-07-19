//
//  Lesson.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/18/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Lesson {
    typealias ID = Int
    
    var id: ID
    let contents: [LessonContent]
    
    init?(id: ID, contents: [LessonContent]) {
        guard !contents.isEmpty else {
            return nil
        }
        self.id = id
        self.contents = contents
    }
    
    static func dummy() -> Lesson {
        let randomContentCount = arc4random() % 3 + 1
        let contents = (0..<randomContentCount).map { _ in LessonContent.dummy() }
        return Lesson(id: 1, contents: contents)!
    }
}

extension Lesson: JSONInitializable {
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let contentsJSON = json["content"].array
        else {
            return nil
        }
        
        let contents = contentsJSON.compactMap({ LessonContent(json: $0) })
        var updatedContents = [LessonContent]()
        if let inputRange = json["input"].dictionary,
            let rangeStart = inputRange["startIndex"]?.int,
            let rangeEnd = inputRange["endIndex"]?.int {
            updatedContents = Lesson.updateInputState(of: contents, withInputStart: rangeStart, andEnd: rangeEnd)
        } else {
            updatedContents = contents
        }
        
        self.init(id: id, contents: updatedContents)
    }
    
    private static func updateInputState(of contents: [LessonContent], withInputStart rangeStart: Int, andEnd rangeEnd: Int) -> [LessonContent] {
        var updatedContents = [LessonContent]()
        var currentStartIndex = 0
        contents.forEach {
            guard currentStartIndex < rangeEnd else {
                updatedContents.append($0)
                return
            }
            
            let textLength = $0.text.count
            if currentStartIndex >= rangeStart {
                // Found a LessonContent that we need to make into input
                let endIndex = currentStartIndex + textLength
                
                if endIndex <= rangeEnd {
                    // Entire LessonContent text inside range, make input
                    var updatedContent = $0
                    updatedContent.isInput = true
                    updatedContents.append(updatedContent)
                    if endIndex == rangeEnd {
                        // Is end of input area, update currentStartIndex so we don't process anymore LessonContent objects
                        currentStartIndex = endIndex
                        return
                    }
                } else {
                    // LessonContent text exceeds end of range, break LessonContent up into input and non-input pieces
                    let currentText = $0.text
                    let indexDivision = currentText.index(currentText.endIndex, offsetBy: rangeEnd - endIndex)
                    let inputText = currentText[..<indexDivision]
                    let nonInputText = currentText[indexDivision...]
                    if
                        let inputContent = LessonContent(color: $0.color, text: String(inputText), isInput: true),
                        let nonInputContent = LessonContent(color: $0.color, text: String(nonInputText))
                    {
                        updatedContents.append(inputContent)
                        updatedContents.append(nonInputContent)
                    } else {
                        // TODO: Add debug log
                    }
                    currentStartIndex = endIndex
                    return
                }
            } else {
                updatedContents.append($0)
            }
            currentStartIndex += textLength
        }
        return updatedContents
    }
}
