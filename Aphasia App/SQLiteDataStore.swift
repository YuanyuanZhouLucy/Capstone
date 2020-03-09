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
    static let instance = SQLiteDataStore()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/aphasiaUserData.sqlite3")
            //run this line if you're getting a seg fault
            //deleteTables()
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }

    func createTable() {
        UsersHelper.createTable(db: db)
        ExerciseAProgressHelper.createTable(db: db)
        ExerciseBProgressHelper.createTable(db: db)
    }
    
    func deleteTables() {
        UsersHelper.deleteUserTable(db: db)
    }
    
    //MARK: User functions
    func addUser(cuserName: String, cslpName: String, cslpEmail: String) -> Int64? {
        return UsersHelper.addUser(db: db, cuserName: cuserName, cslpName: cslpName, cslpEmail: cslpEmail)
    }
    
    func getUser() -> User {
        return UsersHelper.getUser(db: db)
    }
    
    func getUserUploadId() -> Int {
        let user = getUser()
        return user.uploadId
    }
    
    func updateUser(newUserName: String, newSlpName: String, newSlpEmail: String) -> Bool {
        return UsersHelper.updateUser(db: db, newUserName: newUserName, newSlpName: newSlpName, newSlpEmail: newSlpEmail)
    }
    
    func deleteUser() -> Bool {
        return self.updateUser(newUserName: "", newSlpName: "", newSlpEmail: "")
    }
    
    //MARK: Session progress function
    func getExerciseASessionProgress() -> [SessionProgress] {
        return ExerciseAProgressHelper.getAllSession(db: db)
    }
    
    func getExerciseALatestSessionProgress() -> SessionProgress? {
        return ExerciseAProgressHelper.getLastSession(db: db)
    }
    
    func addExerciseASession(date:Date, exercisesAttempted:Int, exercisesCorrect:Int) -> Int64? {
        return ExerciseAProgressHelper.insertSession(db: db, date: date, cexercisesAttempted: exercisesAttempted, cexercisesCorrect:exercisesCorrect)
    }
    
    func getExerciseBSessionProgress() -> [SessionProgress] {
        return ExerciseBProgressHelper.getAllSession(db: db)
    }
    
    func getExerciseBLatestSessionProgress() -> SessionProgress? {
        return ExerciseBProgressHelper.getLastSession(db:db)
    }
    
    func addExerciseBSession(date:Date, exercisesAttempted:Int, exercisesCorrect:Int) -> Int64? {
        return ExerciseBProgressHelper.insertSession(db: db, date: date, cexercisesAttempted: exercisesAttempted, cexercisesCorrect:exercisesCorrect)
    }
    
    func deleteExerciseAProgress() {
        ExerciseAProgressHelper.deleteProgressTable(db: db)
    }
    
    func deleteExerciseBProgress(){
        ExerciseBProgressHelper.deleteProgressTable(db: db)
    }
}
