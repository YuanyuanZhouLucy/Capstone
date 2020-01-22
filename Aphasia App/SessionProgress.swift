//
//  SessionProgress.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-12.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation

class SessionProgress {
    var sessionEndTime:Date
    var exercisesAttempted:Int
    var exercisesCorrect:Int
    
    init(sessionEndTime:Date, exercisesAttempted:Int, exercisesCorrect:Int) {
        self.sessionEndTime = sessionEndTime
        self.exercisesAttempted = exercisesAttempted
        self.exercisesCorrect = exercisesCorrect
    }
}
