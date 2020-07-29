//
//  SQLiteDatabase.swift
//  ECommerce
//
//  Created by Nishita Shukla on 29/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabase:NSObject
{
    var database:OpaquePointer? = nil
    var writableDBPath:String?
    
    init(dbFileName fileName:String, deleteEditableCopy isDelete:Bool)
    {
        super.init()
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        
        writableDBPath  =   documentDirectoryPath + "/" + fileName
        
        let fileManager =   FileManager.default
        
        if !fileManager.fileExists(atPath: writableDBPath!)
        {
            //The DB file does not exist inside the Document Directory than copy from Bundle to the document directory
            
            let bundleDBPath =  Bundle.main.resourcePath! + "/" + fileName
            
            var error: NSError?
            
            do {
                try fileManager.copyItem(atPath: bundleDBPath, toPath: writableDBPath!)
            } catch let error1 as NSError {
                error = error1
                print("db can not be copied to document directory \(error!.description)")
            }
        }
        
        //writableDBPath  =   NSBundle.mainBundle().resourcePath! + "/" + fileName
        
        print("writableDBPath:  \(writableDBPath!)")
    }
    
    func initializeStatement(sqlStatement statement:inout OpaquePointer?,query sqlQuery:String)
    {
    
        if(statement == nil)
        {
            if sqlite3_prepare_v2(database, (sqlQuery as NSString).utf8String, -1, &statement , nil) != SQLITE_OK
            {
                print("Error while preparing statment \(sqlite3_prepare_v2(database,(sqlQuery as NSString).utf8String, -1,&statement , nil))")
            }
        }
    }
    
    //MARK: Function to execute DELETE, UPDATE, and INSERT statements.
    func executeUpdate(sqlStatement statement:OpaquePointer)// -> Bool
    {
//        let resultCode = executeStatement(sqlStatement: statement, success:Int(SQLITE_DONE))
        executeStatement(sqlStatement: statement, success:Int(SQLITE_DONE))
        sqlite3_reset(statement)
        //return resultCode
    }
    
    //MARK: Function to execute SELECT statements.
    //Note: You must call sqlite3_reset after you're done.
    func executeSelect(sqlStatement statement:OpaquePointer) -> Bool
    {
        return executeStatement(sqlStatement: statement, success: Int(SQLITE_ROW))
    }

    //MARK: Convenience function to execute COUNT statements.
    //NOTE: You must call sqlite3_reset after you're done.
    func executeCount(sqlStatement statement:OpaquePointer) //-> Bool
    {
//        return executeStatement(sqlStatement: statement, success: Int(SQLITE_ROW))
        executeStatement(sqlStatement: statement, success: Int(SQLITE_ROW))
    }

    //MARK: Execute Statement Method
    func executeStatement(sqlStatement statement:OpaquePointer,success successConstant:Int) -> Bool
    {
        let success = Int(sqlite3_step(statement))
        
        if success != successConstant
        {
            //print("Statement \(successConstant) failed with error \(success)")
            return false
        }
        
        return true
    }
    
}
