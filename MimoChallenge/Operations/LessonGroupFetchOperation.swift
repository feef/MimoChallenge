//
//  LessonGroupFetchOperation.swift
//  MimoChallenge
//
//  Created by sharif ahmed on 7/19/18.
//  Copyright © 2018 Feef Anthony. All rights reserved.
//

import Foundation
import SwiftyJSON

class LessonGroupFetchOperation: AsynchronousOperation, ResultGeneratingOperation {
    private struct Constants {
        static let url = URL(string: "https://mimochallenge.azurewebsites.net/api/lessons")!
    }
    typealias OnComplete = (OperationResult<[Lesson]>) -> Void
    
    internal let onComplete: OnComplete
    
    init(onComplete: @escaping OnComplete) {
        self.onComplete = onComplete
        super.init()
    }
    
    override func start() {
        super.start()
        let dataTask = URLSession.shared.dataTask(with: Constants.url) { (data, response, error) in
            let result: OperationResult<LessonGroupFetchOperation.ResultType>
            defer {
                self.onComplete(result)
                self.state = .finished
            }
            guard let data = data else {
                result = .failure(error)
                return
            }
            
            let json = JSON(data)
            guard let lessonsJSON = json["lessons"].array else {
                // TODO: Put custom error here
                result = .failure(error)
                return
            }
            let lessons = lessonsJSON.compactMap({ Lesson(json: $0) })
            result = .success(lessons)
        }
        dataTask.resume()
    }
}
