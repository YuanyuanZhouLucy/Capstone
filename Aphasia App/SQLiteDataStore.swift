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
        
        var firstTime = false
        
        do {
            try db!.scalar(users.exists)
        }
        catch {
            firstTime = true
        }
        
        do {
            try db!.run(users.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(uploadId, unique: true)
                table.column(userName)
                table.column(slpName)
                table.column(slpEmail)
                })
            if firstTime {
                self.addUser(cuserName: "default", cslpName: "", cslpEmail: "")
            }
        } catch {
            print("Unable to create table")
        }
    }
    
    func deleteUserTable() {
        do {
            try db!.run(users.drop(ifExists: true))
        } catch {
            print("Unable to delete users table")
        }
    }
    
    func addUser(cuserName: String, cslpName: String, cslpEmail: String) -> Int64? {
        do {
            let cuploadId = Int.random(in: 10 ... 10000)
            let insert = users.insert(uploadId <- cuploadId, userName <- cuserName, slpName <- cslpName, slpEmail <- cslpEmail)
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
                    uploadId: user[uploadId],
                    userName: user[userName]!,
                    slpName: user[slpName],
                    slpEmail: user[slpEmail]))
            }
        } catch {
            print("Select failed")
        }
        
        return user_list[0]
    }
    
    func getUserUploadId() -> Int {
        let user = getUser()
        return user.uploadId
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
}
