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
    private let uploadId = Expression<Int>("uploadId")
    private let userName = Expression<String?>("userName")
    private let slpName = Expression<String>("slpName")
    private let slpEmail = Expression<String>("slpEmail")
    
    static let instance = SQLiteDataStore()
    private let db: Connection?
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/aphasiaUserData.sqlite3")
            //run this line if you're getting a seg fault
            //deleteUserTable()
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }

    func createTable() {
        UsersHelper.createTable(db: db)
    }
    
    //MARK: User functions
    func deleteUserTable() {
        do {
            try db!.run(users.drop(ifExists: true))
        } catch {
            print("Unable to delete users table")
        }
    }
    
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
}
