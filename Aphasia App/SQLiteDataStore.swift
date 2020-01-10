//
//  UserDB.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-09.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDataStore {
    private let users = Table("users")
    private let id = Expression<Int64>("id")
    private let userName = Expression<String?>("userName")
    private let slpName = Expression<String>("slpName")
    private let slpEmail = Expression<String>("slpEmail")
    
    private let progress = Table("progress")
    private let sessionid = Expression<Int64>("sessionid")
    private let sessionTime = Expression<Date?>("sessionTime")
    private let numExerciseAAttempted = Expression<Int>("numExerciseAAttempted")
    private let numExerciseACorrect = Expression<Int>("numExerciseACorrect")
    private let numExerciseBAttempted = Expression<Int>("numExerciseBAttempted")
    private let numExerciseBCorrect = Expression<Int>("numExerciseBCorrect")
    
    static let instance = SQLiteDataStore()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/aphasiaUserData.sqlite3")
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        self.addUser(cuserName: "default", cslpName: "", cslpEmail: "")
        self.addSessionProgress(cSessionTime: Date(), cNumExerciseAAttempted: 1, cNumExerciseACorrect: 3, cNumExerciseBAttempted: 5, cNumExerciseBCorrect: 6)

    }
    
    func createTable() {
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(userName)
                table.column(slpName)
                table.column(slpEmail)
                })
            try db!.run(progress.create(ifNotExists: true) { table in
                table.column(sessionid, primaryKey: true)
                table.column(sessionTime)
                table.column(numExerciseAAttempted)
                table.column(numExerciseACorrect)
                table.column(numExerciseBAttempted)
                table.column(numExerciseBCorrect)
                })
        } catch {
            print("Unable to create table")
        }
    }
    
    //TODO - make User class
    func addUser(cuserName: String, cslpName: String, cslpEmail: String) -> Int64? {
        do {
            let insert = users.insert(userName <- cuserName, slpName <- cslpName, slpEmail <- cslpEmail)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getUser() -> User {
        var user_list = [User]()
        
        do {
            for user in try db!.prepare(self.users) {
                user_list.append(User(
                    userName: user[userName]!,
                    slpName: user[slpName],
                    slpEmail: user[slpEmail]))
            }
        } catch {
            print("Select failed")
        }
        
        return user_list[0]
    }
    
    func updateUser(newUserName: String, newSlpName: String, newSlpEmail: String) -> Bool {
        let user = users.filter(id == 1)
        do {
            let update = user.update([
                userName <- newUserName,
                slpName <- newSlpName,
                slpEmail <- newSlpEmail
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteUser() -> Bool {
        return self.updateUser(newUserName: "", newSlpName: "", newSlpEmail: "")
    }
    
    //TODO: Make Progress class
    func addSessionProgress(cSessionTime:Date, cNumExerciseAAttempted:Int, cNumExerciseACorrect:Int, cNumExerciseBAttempted:Int, cNumExerciseBCorrect:Int) -> Int64? {
        do {
            let insert = progress.insert(sessionTime <- cSessionTime, numExerciseAAttempted <- cNumExerciseAAttempted, numExerciseACorrect <- cNumExerciseACorrect, numExerciseBAttempted <- cNumExerciseBAttempted, numExerciseBCorrect <- cNumExerciseBCorrect)
            let sessionid = try db!.run(insert)
            
            return sessionid
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    func getProgressData() -> [SessionProgess] {
        var progressData = [SessionProgess]()
        
        do {
            for session in try db!.prepare(self.progress) {
                progressData.append(SessionProgess(
                    sessionTime: session[sessionTime]!,
                    numExerciseAAttempted: session[numExerciseAAttempted],
                    numExerciseACorrect: session[numExerciseACorrect],
                    numExerciseBAttempted: session[numExerciseBAttempted],
                    numExerciseBCorrect: session[numExerciseBCorrect]))
            }
        } catch {
            print("Select failed")
        }
        
        return progressData
    }
    
    func deleteOldProgressData() -> Bool {
        //TODO: keeps only 30 records
        
        return true
    }
}
