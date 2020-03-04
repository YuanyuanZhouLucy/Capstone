//
//  QuestionBank.swift
//  Aphasia App
//
//  Created by Yuanyuan Zhou on 2019-11-21.
//  Copyright © 2019 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class QuestionBank {
    var list = [Question] ()
    var category = ""
    let ref = Database.database().reference()
    let nonRelatedWord = ["Caffeine", "Brandywine", "Chesapeake"]
    let wrongAnswer = ["plastic bag", "pencase", "bottle","water","phone","bookstore"]
    let uid = SQLiteDataStore.instance.getUserUploadId()
    var size = 0
    
    init() {
        
        let locationType = locationTypeGV
        print("locationTypeGV")
        print(locationTypeGV)
        print("the location i got is:")
        print(locationType)
        if(locationTypeGV == "food" || locationTypeGV == "restaurant" || locationTypeGV == "cafe"){
            category = "Cafe"
        }
        else if(locationTypeGV == "grocery_or_supermarket"){
            category = "GroceryStore"
        }
        else if(locationTypeGV == "hospital"){
            category = "Hospital"
        }
        else if(locationTypeGV == "park"){
            category = "Park"
        }
        print("the category is:")
        print(category)
        ref.child(category).observeSingleEvent(of: .value, with:{(snapshot) in
            let value  = snapshot.value as? NSDictionary
            let value2  = snapshot.value as? NSDictionary
            let value3  = snapshot.value as? NSDictionary
            let value4  = snapshot.value as? NSDictionary
            let value5  = snapshot.value as? NSDictionary
            let value6  = snapshot.value as? NSDictionary
            let value7  = snapshot.value as? NSDictionary
            let value8  = snapshot.value as? NSDictionary
            let value9  = snapshot.value as? NSDictionary
            let value10  = snapshot.value as? NSDictionary
            func makeList(_ n: Int) -> [Int] {
                return (0..<n).map { _ in .random(in: 1...5) }
            }
            var randomNumbers = makeList(5)
            //uncomment for testing
            randomNumbers = [1,2,3,4,5]
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
            
            
            let sizeList1 = self.nonRelatedWord.count
            let sizeList2 = self.wrongAnswer.count
            let randomNonRelatedWordPicker = Int.random(in: 0..<sizeList1)
            let    randomNonRelatedWordPicker2 = Int.random(in: 0..<sizeList2)
            
            
            
            let Exercise = value?["Exercise" + String(randomNumbers[0])] as? NSDictionary
            let imageURL = Exercise?["ImageURL"] as? String ?? ""
            let answer = Exercise?["Answer"] as? String ?? ""
            let wrong11=Exercise?["Wrong1"] as? String ?? ""
            let wrong12=Exercise?["Wrong2"] as? String ?? ""
            let wrong13=Exercise?["Wrong3"] as? String ?? ""
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
            let wrong21=Exercise2?["Wrong1"] as? String ?? ""
            let wrong22=Exercise2?["Wrong2"] as? String ?? ""
            let wrong23=Exercise2?["Wrong3"] as? String ?? ""
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
            let wrong31=Exercise3?["Wrong1"] as? String ?? ""
            let wrong32=Exercise3?["Wrong2"] as? String ?? ""
            let wrong33=Exercise3?["Wrong3"] as? String ?? ""
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
            let wrong41=Exercise4?["Wrong1"] as? String ?? ""
            let wrong42=Exercise4?["Wrong2"] as? String ?? ""
            let wrong43=Exercise4?["Wrong3"] as? String ?? ""
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
            let wrong51=Exercise5?["Wrong1"] as? String ?? ""
            let wrong52=Exercise5?["Wrong2"] as? String ?? ""
            let wrong53=Exercise5?["Wrong3"] as? String ?? ""
            let cue51 = Exercise5?["Cue1"] as? String ?? ""
            let cue52 = Exercise5?["Cue2"] as? String ?? ""
            let cue53 = Exercise5?["Cue3"] as? String ?? ""
            let cue54 = Exercise5?["Cue4"] as? String ?? ""
            let r51 = Exercise5?["Opt1"] as? String ?? ""
            let r52 = Exercise5?["Opt2"] as? String ?? ""
            let r53 = Exercise5?["Opt3"] as? String ?? ""
            let r54 = Exercise5?["Opt4"] as? String ?? ""
            let wrongOpt5 = Exercise5?["WrongOpt"] as? Int ?? 1
            
            let Exercise6 = value6?["Exercise6" ] as? NSDictionary
            let imageURL6 = Exercise6?["ImageURL"] as? String ?? ""
            let answer6 = Exercise6?["Answer"] as? String ?? ""
            let wrong61=Exercise6?["Wrong1"] as? String ?? ""
            let wrong62=Exercise6?["Wrong2"] as? String ?? ""
            let wrong63=Exercise6?["Wrong3"] as? String ?? ""
            let cue61 = Exercise6?["Cue1"] as? String ?? ""
            let cue62 = Exercise6?["Cue2"] as? String ?? ""
            let cue63 = Exercise6?["Cue3"] as? String ?? ""
            let cue64 = Exercise6?["Cue4"] as? String ?? ""
            let r61 = Exercise6?["Opt1"] as? String ?? ""
            let r62 = Exercise6?["Opt2"] as? String ?? ""
            let r63 = Exercise6?["Opt3"] as? String ?? ""
            let r64 = Exercise6?["Opt4"] as? String ?? ""
            let wrongOpt6 = Exercise6?["WrongOpt"] as? Int ?? 1
            
            
            let Exercise7 = value7?["Exercise7"] as? NSDictionary
            let imageURL7 = Exercise7?["ImageURL"] as? String ?? ""
            let answer7 = Exercise7?["Answer"] as? String ?? ""
            let wrong71=Exercise7?["Wrong1"] as? String ?? ""
            let wrong72=Exercise7?["Wrong2"] as? String ?? ""
            let wrong73=Exercise7?["Wrong3"] as? String ?? ""
            let cue71 = Exercise7?["Cue1"] as? String ?? ""
            let cue72 = Exercise7?["Cue2"] as? String ?? ""
            let cue73 = Exercise7?["Cue3"] as? String ?? ""
            let cue74 = Exercise7?["Cue4"] as? String ?? ""
            let r71 = Exercise7?["Opt1"] as? String ?? ""
            let r72 = Exercise7?["Opt2"] as? String ?? ""
            let r73 = Exercise7?["Opt3"] as? String ?? ""
            let r74 = Exercise7?["Opt4"] as? String ?? ""
            let wrongOpt7 = Exercise7?["WrongOpt"] as? Int ?? 1
            
            
            let Exercise8 = value8?["Exercise8"] as? NSDictionary
            let imageURL8 = Exercise8?["ImageURL"] as? String ?? ""
            let answer8 = Exercise8?["Answer"] as? String ?? ""
            let wrong81=Exercise8?["Wrong1"] as? String ?? ""
            let wrong82=Exercise8?["Wrong2"] as? String ?? ""
            let wrong83=Exercise8?["Wrong3"] as? String ?? ""
            let cue81 = Exercise8?["Cue1"] as? String ?? ""
            let cue82 = Exercise8?["Cue2"] as? String ?? ""
            let cue83 = Exercise8?["Cue3"] as? String ?? ""
            let cue84 = Exercise8?["Cue4"] as? String ?? ""
            let r81 = Exercise8?["Opt1"] as? String ?? ""
            let r82 = Exercise8?["Opt2"] as? String ?? ""
            let r83 = Exercise8?["Opt3"] as? String ?? ""
            let r84 = Exercise8?["Opt4"] as? String ?? ""
            let wrongOpt8 = Exercise8?["WrongOpt"] as? Int ?? 1
            
            
            let Exercise9 = value9?["Exercise9"] as? NSDictionary
            let imageURL9 = Exercise9?["ImageURL"] as? String ?? ""
            let answer9 = Exercise9?["Answer"] as? String ?? ""
            let wrong91=Exercise9?["Wrong1"] as? String ?? ""
            let wrong92=Exercise9?["Wrong2"] as? String ?? ""
            let wrong93=Exercise9?["Wrong3"] as? String ?? ""
            let cue91 = Exercise9?["Cue1"] as? String ?? ""
            let cue92 = Exercise9?["Cue2"] as? String ?? ""
            let cue93 = Exercise9?["Cue3"] as? String ?? ""
            let cue94 = Exercise9?["Cue4"] as? String ?? ""
            let r91 = Exercise9?["Opt1"] as? String ?? ""
            let r92 = Exercise9?["Opt2"] as? String ?? ""
            let r93 = Exercise9?["Opt3"] as? String ?? ""
            let r94 = Exercise9?["Opt4"] as? String ?? ""
            let wrongOpt9 = Exercise9?["WrongOpt"] as? Int ?? 1
            
            
            
            let Exercise10 = value10?["Exercise10" ] as? NSDictionary
            let imageURL10 = Exercise10?["ImageURL"] as? String ?? ""
            let answer10 = Exercise10?["Answer"] as? String ?? ""
            let wrong101=Exercise10?["Wrong1"] as? String ?? ""
            let wrong102=Exercise10?["Wrong2"] as? String ?? ""
            let wrong103=Exercise10?["Wrong3"] as? String ?? ""
            let cue101 = Exercise10?["Cue1"] as? String ?? ""
            let cue102 = Exercise10?["Cue2"] as? String ?? ""
            let cue103 = Exercise10?["Cue3"] as? String ?? ""
            let cue104 = Exercise10?["Cue4"] as? String ?? ""
            let r101 = Exercise10?["Opt1"] as? String ?? ""
            let r102 = Exercise10?["Opt2"] as? String ?? ""
            let r103 = Exercise10?["Opt3"] as? String ?? ""
            let r104 = Exercise10?["Opt4"] as? String ?? ""
            let wrongOpt10 = Exercise10?["WrongOpt"] as? Int ?? 1
            
            
            
            
            self.list.append(Question(image: imageURL, optA: answer, optB: wrong11,optC:wrong12,optD:wrong13, answer: 1,q1:cue11,q2:cue12,q3:cue13,q4:cue14,r1:r11,r2:r12,r3:r13,r4:r14,wrongOption: wrongOpt1))
            self.list.append(Question(image: imageURL2, optA: wrong21, optB: answer2,optC:wrong22,optD:wrong23, answer: 2,q1:cue21,q2:cue22,q3:cue23,q4:cue24,r1:r21,r2:r22,r3:r23,r4:r24,wrongOption: wrongOpt2))
            self.list.append(Question(image: imageURL3, optA: answer3, optB: wrong31,optC:wrong32,optD:wrong33, answer: 1,q1:cue31,q2:cue32,q3:cue33,q4:cue34,r1:r31,r2:r32,r3:r33,r4:r34,wrongOption: wrongOpt3))
            self.list.append(Question(image: imageURL4, optA: wrong41, optB: answer4,optC:wrong42,optD:wrong43, answer: 2,q1:cue41,q2:cue42,q3:cue43,q4:cue44,r1:r41,r2:r42,r3:r43,r4:r44, wrongOption: wrongOpt4))
            self.list.append(Question(image: imageURL5, optA: answer5, optB:wrong51,optC:wrong52,optD:wrong53, answer: 1,q1:cue51,q2:cue52,q3:cue53,q4:cue54,r1:r51,r2:r52,r3:r53,r4:r54,wrongOption: wrongOpt5))
            self.size = 5
            
            self.list.append(Question(image: imageURL6, optA: answer6, optB: wrong61,optC:wrong62,optD:wrong63, answer: 1,q1:cue61,q2:cue62,q3:cue63,q4:cue64,r1:r61,r2:r62,r3:r63,r4:r64,wrongOption: wrongOpt6))
            self.list.append(Question(image: imageURL7, optA: wrong71, optB: answer7,optC:wrong72,optD:wrong73, answer: 2,q1:cue71,q2:cue72,q3:cue73,q4:cue74,r1:r71,r2:r72,r3:r73,r4:r74,wrongOption: wrongOpt7))
            self.list.append(Question(image: imageURL8, optA: answer8, optB: wrong81,optC:wrong82,optD:wrong83, answer: 1,q1:cue81,q2:cue82,q3:cue83,q4:cue84,r1:r81,r2:r82,r3:r83,r4:r84,wrongOption: wrongOpt8))
            self.list.append(Question(image: imageURL9, optA: wrong91, optB: answer9,optC:wrong92,optD:wrong93, answer: 2,q1:cue91,q2:cue92,q3:cue93,q4:cue94,r1:r91,r2:r92,r3:r93,r4:r94, wrongOption: wrongOpt9))
            self.list.append(Question(image: imageURL10, optA: answer10, optB:wrong101,optC:wrong102,optD:wrong103, answer: 1,q1:cue101,q2:cue102,q3:cue103,q4:cue104,r1:r101,r2:r102,r3:r103,r4:r104,wrongOption: wrongOpt10))
            self.size = 10
        })
        
        
        ref.child("userDefinedEx").child("uid\(uid)").observeSingleEvent(of: .value, with: {(snapshot1)in
            if snapshot1.hasChild(self.category){
                self.ref.child("userDefinedEx").child("uid\(self.uid)").child(self.category).observeSingleEvent(of: .value, with:{(snapshot) in
                    for individualSnap in snapshot.children{
                        let snap = individualSnap as! DataSnapshot
                        print(snap)
                        let imageURL = (snap.value as? NSDictionary)?["ImageURL"] as? String ?? ""
                        let answer = ((snap.value as? NSDictionary)?["Answer"] as? String ?? "").capitalizingFirstLetter()
                        let wrong11=((snap.value as? NSDictionary)?["Wrong1"] as? String ?? "").capitalizingFirstLetter()
                        let wrong12=((snap.value as? NSDictionary)?["Wrong2"] as? String ?? "").capitalizingFirstLetter()
                        let wrong13=((snap.value as? NSDictionary)?["Wrong3"] as? String ?? "").capitalizingFirstLetter()
                        let cue11 = ((snap.value as? NSDictionary)?["Cue1"] as? String ?? "").capitalizingFirstLetter()
                        let cue12 = ((snap.value as? NSDictionary)?["Cue2"] as? String ?? "").capitalizingFirstLetter()
                        let cue13 = ((snap.value as? NSDictionary)?["Cue3"] as? String ?? "").capitalizingFirstLetter()
                        let cue14 = ((snap.value as? NSDictionary)?["Cue4"] as? String ?? "").capitalizingFirstLetter()
                        let r11 = ((snap.value as? NSDictionary)?["Opt1"] as? String ?? "").capitalizingFirstLetter()
                        let r12 = ((snap.value as? NSDictionary)?["Opt2"] as? String ?? "").capitalizingFirstLetter()
                        let r13 = ((snap.value as? NSDictionary)?["Opt3"] as? String ?? "").capitalizingFirstLetter()
                        let r14 = ((snap.value as? NSDictionary)?["Opt4"] as? String ?? "").capitalizingFirstLetter()
                        let wrongOpt1 = (snap.value as? NSDictionary)?["WrongOpt"] as? Int ?? 1
                        self.list.append(Question(image: imageURL, optA: answer, optB: wrong11,optC:wrong12,optD:wrong13, answer: 1,q1:cue11,q2:cue12,q3:cue13,q4:cue14,r1:r11,r2:r12,r3:r13,r4:r14,wrongOption: wrongOpt1))
                        
                        self.size += 1
                    }
                })
            }
        })
        
        
    }
}
