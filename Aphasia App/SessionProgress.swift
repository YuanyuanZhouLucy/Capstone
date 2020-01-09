//
//  SessionProgress.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation

class SessionProgess {
    var sessionTime: Date
    var numExerciseAAttempted: Int
    var numExerciseACorrect: Int
    var numExerciseBAttempted: Int
    var numExerciseBCorrect: Int
    
    init(sessionTime: Date, numExerciseAAttempted:Int, numExerciseACorrect:Int, numExerciseBAttempted:Int, numExerciseBCorrect:Int) {
        self.sessionTime = sessionTime
        self.numExerciseAAttempted = numExerciseAAttempted
        self.numExerciseACorrect = numExerciseACorrect
        self.numExerciseBAttempted = numExerciseBAttempted
        self.numExerciseBCorrect = numExerciseBCorrect
    }
}
