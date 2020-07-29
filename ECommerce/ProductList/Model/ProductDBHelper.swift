//
//  ProductDBHelper.swift
//  ECommerce
//
//  Created by Nishita Shukla on 29/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation
import SQLite3

class ProductDBHelper:SQLiteDatabase
{
    static var instance : ProductDBHelper = {
        let instance1 = ProductDBHelper()
        return instance1
    }()
    
    class func sharedInstance() -> ProductDBHelper
    {
        return instance
    }
    
    private init()
    {
        //assert(Static.instance == nil, "Attempted to create second instance of AsynFileManagerDB")
        super.init(dbFileName: "ecommerce.sqlite", deleteEditableCopy: false)
        
        if sqlite3_open((writableDBPath! as NSString).utf8String, &database) == SQLITE_OK
        {
            print("Data base created successfully");
        }
    }
    
    func insertStatemnt()
    {
        print("insert statement");
    }
    
    
}
