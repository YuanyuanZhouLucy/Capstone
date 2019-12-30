//
//  QuestionBank.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-21.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import Foundation

class Question{
    let questionImage: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
    let correctAnswer: Int
    let cue1: String
    let cue2: String
    let cue3: String
    let cue4: String
    let relatedWord1: String
    let relatedWord2: String
    let relatedWord3: String
    let relatedWord4: String
    let wrongOpt: Int
    
    init(image:String, optA: String, optB: String, optC: String, optD: String, answer: Int, q1: String,q2:String,q3:String,q4:String,r1:String,r2:String,r3:String,r4:String,wrongOption:Int){
        questionImage=image
        optionA = optA
        optionB = optB
        optionC = optC
        optionD = optD
        correctAnswer = answer
        cue1 = q1
        cue2 = q2
        cue3 = q3
        cue4 = q4
        relatedWord1 = r1
        relatedWord2 = r2
        relatedWord3 = r3
        relatedWord4 = r4
        wrongOpt = wrongOption
        
    }
    
}
