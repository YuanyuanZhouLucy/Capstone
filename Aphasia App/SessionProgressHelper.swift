//
//  SessionProgressHelper.swift
//  Aphasia App
//
//  Created by Katherine Bancroft on 2020-01-12.
//  Copyright © 2020 Yuanyuan Zhou. All rights reserved.
//

import Foundation
import SQLite


class ExerciseAProgressHelper {
    static let exerciseAProgress = Table("exerciseA")
    static let id = Expression<Int64>("id")
    static let sessionEndTime = Expression<Date>("sessionEndTime")
    static let exercisesAttempted = Expression<Int>("exercisesAttempted")
    static let exercisesCorrect = Expression<Int>("exercisesCorrect")
    
    static func createTable(db: Connection?) {
        do {
            try db!.run(exerciseAProgress.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(sessionEndTime)
                table.column(exercisesAttempted)
                table.column(exercisesCorrect)
                })
        } catch {
            print("Unable to create Exercise A table")
        }
        
    }
    
    static func insertSession(db: Connection?, date:Date, cexercisesAttempted: Int, cexercisesCorrect: Int) -> Int64? {
        
        do {
            let insert = exerciseAProgress.insert(sessionEndTime <- date, exercisesAttempted <- cexercisesAttempted, exercisesCorrect <- cexercisesCorrect)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
        
    }
    
    static func getAllSession(db: Connection?) -> [SessionProgress]{
            var sessions = [SessionProgress]()
            
            do {
                for session in try db!.prepare(self.exerciseAProgress) {
                    sessions.append(SessionProgress(
                        sessionEndTime: session[sessionEndTime],
                        exercisesAttempted: session[exercisesAttempted],
                        exercisesCorrect: session[exercisesCorrect]))
                }
            } catch {
                print("Select failed")
            }
            
            return sessions
        
    }
    
    static func getLastSession(db:Connection?) -> SessionProgress? {
        let sessions = ExerciseAProgressHelper.getAllSession(db: db)
        if sessions.count > 0 {
            return sessions.last
        }
        return nil
    }
    
}

class ExerciseBProgressHelper {
    static let exerciseBProgress = Table("exerciseB")
    static let id = Expression<Int64>("id")
    static let sessionEndTime = Expression<Date>("sessionEndTime")
    static let exercisesAttempted = Expression<Int>("exercisesAttempted")
    static let exercisesCorrect = Expression<Int>("exercisesCorrect")
    
    static func createTable(db: Connection?) {
        do {
            try db!.run(exerciseBProgress.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(sessionEndTime)
                table.column(exercisesAttempted)
                table.column(exercisesCorrect)
                })
        } catch {
            print("Unable to create Exercise B table")
        }
        
    }
    
    static func insertSession(db: Connection?, date:Date, cexercisesAttempted: Int, cexercisesCorrect: Int) -> Int64? {
        
        do {
            let insert = exerciseBProgress.insert(sessionEndTime <- date, exercisesAttempted <- cexercisesAttempted, exercisesCorrect <- cexercisesCorrect)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    static func getAllSession(db: Connection?) -> [SessionProgress]{
            var sessions = [SessionProgress]()
            
            do {
                for session in try db!.prepare(self.exerciseBProgress) {
                    sessions.append(SessionProgress(
                        sessionEndTime: session[sessionEndTime],
                        exercisesAttempted: session[exercisesAttempted],
                        exercisesCorrect: session[exercisesCorrect]))
                }
            } catch {
                print("Select failed")
            }
            
            return sessions
        
    }
    
    static func getLastSession(db:Connection?) -> SessionProgress? {
        let sessions = ExerciseBProgressHelper.getAllSession(db: db)
        if sessions.count > 0 {
            return sessions.last
        }
        return nil
    }
}
