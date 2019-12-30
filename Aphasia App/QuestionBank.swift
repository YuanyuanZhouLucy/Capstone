//
//  QuestionBank.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-21.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import FirebaseDatabase

class QuestionBank {
    var list = [Question] ()
    let ref = Database.database().reference()
    
    init() {
        ref.child("Cafe").observeSingleEvent(of: .value, with:{(snapshot) in
            let value  = snapshot.value as? NSDictionary
            let value2  = snapshot.value as? NSDictionary
            let value3  = snapshot.value as? NSDictionary
            let value4  = snapshot.value as? NSDictionary
            let value5  = snapshot.value as? NSDictionary
            
            func makeList(_ n: Int) -> [Int] {
                return (0..<n).map { _ in .random(in: 1...5) }
            }
            let randomNumbers = makeList(5)
            print("all random numbers")
            print(randomNumbers)
            
            let example = value?.allValues
            let keys = value?.allKeys
            print("example")
            print(example)
            
            
            let random = Int.random(in: 0..<5)
            let randomString = String(random)
            print("randomString is")
            print(randomString)
            
            let Exercise = value?["Exercise" + String(randomNumbers[0])] as? NSDictionary
            let imageURL = Exercise?["ImageURL"] as? String ?? ""
            let answer = Exercise?["Answer"] as? String ?? ""
            let cue11 = Exercise?["Cue1"] as? String ?? ""
            let cue12 = Exercise?["Cue2"] as? String ?? ""
            let cue13 = Exercise?["Cue3"] as? String ?? ""
            let cue14 = Exercise?["Cue4"] as? String ?? ""
            let r11 = Exercise?["Opt1"] as? String ?? ""
            let r12 = Exercise?["Opt2"] as? String ?? ""
            let r13 = Exercise?["Opt3"] as? String ?? ""
            let r14 = Exercise?["Opt4"] as? String ?? ""
            let wrongOpt1 = Exercise?["WrongOpt"] as? Int ?? 1
            
            print("inside question bank")
                print(wrongOpt1)
            let Exercise2 = value2?["Exercise" + String(randomNumbers[1])] as? NSDictionary
            let imageURL2 = Exercise2?["ImageURL"] as? String ?? ""
            let answer2 = Exercise2?["Answer"] as? String ?? ""
            let cue21 = Exercise2?["Cue1"] as? String ?? ""
            let cue22 = Exercise2?["Cue2"] as? String ?? ""
            let cue23 = Exercise2?["Cue3"] as? String ?? ""
            let cue24 = Exercise2?["Cue4"] as? String ?? ""
            let r21 = Exercise2?["Opt1"] as? String ?? ""
            let r22 = Exercise2?["Opt2"] as? String ?? ""
            let r23 = Exercise2?["Opt3"] as? String ?? ""
            let r24 = Exercise2?["Opt4"] as? String ?? ""
            let wrongOpt2 = Exercise2?["WrongOpt"] as? Int ?? 1
            
            let Exercise3 = value3?["Exercise" + String(randomNumbers[2])] as? NSDictionary
            let imageURL3 = Exercise3?["ImageURL"] as? String ?? ""
            let answer3 = Exercise3?["Answer"] as? String ?? ""
            let cue31 = Exercise3?["Cue1"] as? String ?? ""
            let cue32 = Exercise3?["Cue2"] as? String ?? ""
            let cue33 = Exercise3?["Cue3"] as? String ?? ""
            let cue34 = Exercise3?["Cue4"] as? String ?? ""
            let r31 = Exercise3?["Opt1"] as? String ?? ""
            let r32 = Exercise3?["Opt2"] as? String ?? ""
            let r33 = Exercise3?["Opt3"] as? String ?? ""
            let r34 = Exercise3?["Opt4"] as? String ?? ""
            let wrongOpt3 = Exercise3?["WrongOpt"] as? Int ?? 1
            
            let Exercise4 = value4?["Exercise" + String(randomNumbers[3])] as? NSDictionary
            let imageURL4 = Exercise4?["ImageURL"] as? String ?? ""
            let answer4 = Exercise4?["Answer"] as? String ?? ""
            let cue41 = Exercise4?["Cue1"] as? String ?? ""
            let cue42 = Exercise4?["Cue2"] as? String ?? ""
            let cue43 = Exercise4?["Cue3"] as? String ?? ""
            let cue44 = Exercise4?["Cue4"] as? String ?? ""
            let r41 = Exercise4?["Opt1"] as? String ?? ""
            let r42 = Exercise4?["Opt2"] as? String ?? ""
            let r43 = Exercise4?["Opt3"] as? String ?? ""
            let r44 = Exercise4?["Opt4"] as? String ?? ""
            let wrongOpt4 = Exercise4?["WrongOpt"] as? Int ?? 1
            
            let Exercise5 = value5?["Exercise" + String(randomNumbers[4])] as? NSDictionary
            let imageURL5 = Exercise5?["ImageURL"] as? String ?? ""
            let answer5 = Exercise5?["Answer"] as? String ?? ""
            let cue51 = Exercise5?["Cue1"] as? String ?? ""
            let cue52 = Exercise5?["Cue2"] as? String ?? ""
            let cue53 = Exercise5?["Cue3"] as? String ?? ""
            let cue54 = Exercise5?["Cue4"] as? String ?? ""
            let r51 = Exercise5?["Opt1"] as? String ?? ""
            let r52 = Exercise5?["Opt2"] as? String ?? ""
            let r53 = Exercise5?["Opt3"] as? String ?? ""
            let r54 = Exercise5?["Opt4"] as? String ?? ""
            let wrongOpt5 = Exercise5?["WrongOpt"] as? Int ?? 1
            
            self.list.append(Question(image: imageURL, optA: answer, optB: "wrong answer",optC:"wrong",optD:"wrong", answer: 1,q1:cue11,q2:cue12,q3:cue13,q4:cue14,r1:r11,r2:r12,r3:r13,r4:r14,wrongOption: wrongOpt1))
            self.list.append(Question(image: imageURL2, optA: "wrong answer", optB: answer2,optC:"wrong",optD:"wrong", answer: 2,q1:cue21,q2:cue22,q3:cue23,q4:cue24,r1:r21,r2:r22,r3:r23,r4:r24,wrongOption: wrongOpt2))
            self.list.append(Question(image: imageURL3, optA: answer3, optB: "wrong answer",optC:"wrong",optD:"wrong", answer: 1,q1:cue31,q2:cue32,q3:cue33,q4:cue34,r1:r31,r2:r32,r3:r33,r4:r34,wrongOption: wrongOpt3))
            self.list.append(Question(image: imageURL4, optA: "wrong answer", optB: answer4,optC:"wrong",optD:"wrong", answer: 2,q1:cue41,q2:cue42,q3:cue43,q4:cue44,r1:r41,r2:r42,r3:r43,r4:r44, wrongOption: wrongOpt4))
            self.list.append(Question(image: imageURL5, optA: answer5, optB: "wrong answer",optC:"wrong",optD:"wrong", answer: 1,q1:cue51,q2:cue52,q3:cue53,q4:cue54,r1:r51,r2:r52,r3:r53,r4:r54,wrongOption: wrongOpt5))
            
            
        })
    }
}
