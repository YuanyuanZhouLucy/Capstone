//
//  UsersHelper.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-12.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import SQLite

class UsersHelper {
    
    static let users = Table("users")
    static let id = Expression<Int64>("id")
    static let uploadId = Expression<Int>("uploadId")
    static let userName = Expression<String?>("userName")
    static let slpName = Expression<String>("slpName")
    static let slpEmail = Expression<String>("slpEmail")
    
    static func createTable(db: Connection?) {
        
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
                self.addUser(db:db, cuserName: "", cslpName: "", cslpEmail: "")
            }
        } catch {
            print("Unable to create table")
        }
    }
    
    static func addUser(db: Connection?, cuserName: String, cslpName: String, cslpEmail: String) -> Int64? {
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
    
    static func getUser(db: Connection?) -> User {
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
    
    static func updateUser(db: Connection?, newUserName: String, newSlpName: String, newSlpEmail: String) -> Bool {
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
    
    static func deleteUserTable(db: Connection?) {
        do {
            try db!.run(users.drop(ifExists: true))
        } catch {
            print("Unable to delete users table")
        }
    }

}
