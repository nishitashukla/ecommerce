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
    //MARK: Variables
    
    //Categories Table Statements
    /*
     Table name : Categories
     Columns : category_id Int PRIMARY KEY , name TEXT , sub_category_ids TEXT
     Note: Multiple category will be saved comma seperated. Ex: 4,5,6
     */
    var createTableCategories : OpaquePointer? = nil
    var insertIntoCategories : OpaquePointer? = nil
    
    //Products Table Statements
    /*
     Table name : Products
     Columns : product_id Int PRIMARY KEY , name TEXT , dateAdded TEXT , category_id Int , variants_ids TEXT, tax_id int
     Note: Multiple variants will be saved comma seperated. Ex: 4,5,6
     */
    var createTableProducts:OpaquePointer? = nil
    var insertIntoProducts:OpaquePointer? = nil
    
    //Ranking Table Statements
    /*
     Table name : Ranking
     Columns : ranking_id Int PRIMARY KEY AUTOINCREMENT, name TEXT
     */
    var createTableRanking:OpaquePointer? = nil
    var insertIntoRanking:OpaquePointer? = nil
    
    //Ranking Product Table Statements
    /*
     Table name : RankingProduct
     Columns : product_id Int, view_count TEXT, order_count TEXT, shares_count TEXT
     */
    var createTableRankingProduct:OpaquePointer? = nil
    var insertIntoRankingProduct:OpaquePointer? = nil
    
    //Tax Table Statements
    /*
     Table name : Tax
     Columns : name TEXT, value REAL
     */
    var createTableTax:OpaquePointer? = nil
    var insertIntoTax:OpaquePointer? = nil
    var selectTaxId:OpaquePointer?=nil
    
    //Variants Table Statements
    /*
     Table name : Variants
     Columns : variant_id Int, color TEXT, size TEXT , price TEXT
     */
    var createTableVariants:OpaquePointer? = nil
    var insertIntoVariants:OpaquePointer? = nil
    
    
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
        super.init(dbFileName: "ecommerce.sqlite", deleteEditableCopy: false)
        
        if sqlite3_open((writableDBPath! as NSString).utf8String, &database) == SQLITE_OK
        {
            if createTableCategories == nil
            {
                var delete:OpaquePointer? = nil
                               initializeStatement(sqlStatement: &delete, query: "DROP TABLE Categories")
                               executeUpdate(sqlStatement: delete!)
                initializeStatement(sqlStatement: &createTableCategories, query: "CREATE TABLE IF NOT EXISTS Categories(category_id INTEGER PRIMARY KEY, name TEXT,sub_category_ids TEXT)")
                executeUpdate(sqlStatement: createTableCategories!)
            }
            
            if createTableProducts == nil
            {
                
                var delete:OpaquePointer? = nil
                initializeStatement(sqlStatement: &delete, query: "DROP TABLE Products")
                executeUpdate(sqlStatement: delete!)
                
                initializeStatement(sqlStatement: &createTableProducts, query: "CREATE TABLE IF NOT EXISTS Products(product_id INTEGER PRIMARY KEY , name TEXT , dateAdded TEXT , category_id INTEGER , variants_ids TEXT, tax_id INTEGER)")
                executeUpdate(sqlStatement: createTableProducts!)
            }
            
            
            if createTableRanking == nil
            {
                var delete:OpaquePointer? = nil
                initializeStatement(sqlStatement: &delete, query: "DROP TABLE Ranking")
                executeUpdate(sqlStatement: delete!)
                initializeStatement(sqlStatement: &createTableRanking, query: "CREATE TABLE IF NOT EXISTS Ranking(ranking_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)")
                executeUpdate(sqlStatement: createTableRanking!)
            }
            
            
            if createTableRankingProduct == nil
            {
                var delete:OpaquePointer? = nil
                initializeStatement(sqlStatement: &delete, query: "DROP TABLE RankingProduct")
                executeUpdate(sqlStatement: delete!)
                initializeStatement(sqlStatement: &createTableRankingProduct, query: "CREATE TABLE IF NOT EXISTS RankingProduct(product_id INTEGER, view_count TEXT, order_count TEXT, shares_count TEXT)")
                executeUpdate(sqlStatement: createTableRankingProduct!)
            }
            
            
            if createTableTax == nil
            {
                var delete:OpaquePointer? = nil
                initializeStatement(sqlStatement: &delete, query: "DROP TABLE Tax")
                executeUpdate(sqlStatement: delete!)
                initializeStatement(sqlStatement: &createTableTax, query: "CREATE TABLE IF NOT EXISTS Tax(tax_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, value REAL)")
                executeUpdate(sqlStatement: createTableTax!)
            }
            
            
            if createTableVariants == nil
            {
                var delete:OpaquePointer? = nil
                initializeStatement(sqlStatement: &delete, query: "DROP TABLE Variants")
                executeUpdate(sqlStatement: delete!)
                initializeStatement(sqlStatement: &createTableVariants, query: "CREATE TABLE IF NOT EXISTS Variants(variant_id INTEGER, color TEXT, size TEXT , price TEXT)")
                executeUpdate(sqlStatement: createTableVariants!)
            }
        }
    }
    
    func insertCategories(category_id:Int, name:String, sub_category_ids:String)
    {
        if insertIntoCategories == nil
        {
            initializeStatement(sqlStatement: &insertIntoCategories, query: "INSERT INTO Categories (category_id,name,sub_category_ids) VALUES (?,?,?)")
        }
        sqlite3_bind_int(insertIntoCategories, 1, CInt(category_id))
        sqlite3_bind_text(insertIntoCategories, 2, (name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoCategories, 3, (sub_category_ids as NSString).utf8String, -1, nil)
        executeUpdate(sqlStatement: insertIntoCategories!)
    }
    
    func insertProducts(product_id:Int, name:String, dateAdded:String,category_id:Int,variants_ids:String,tax_id:Int)
    {
        if insertIntoProducts == nil
        {
            initializeStatement(sqlStatement: &insertIntoProducts, query: "INSERT INTO Products (product_id, name, dateAdded, category_id , variants_ids, tax_id) VALUES (?,?,?,?,?,?)")
        }
        sqlite3_bind_int(insertIntoProducts, 1, CInt(product_id))
        sqlite3_bind_text(insertIntoProducts, 2, (name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoProducts, 3, (dateAdded as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertIntoProducts, 4, CInt(category_id))
        sqlite3_bind_text(insertIntoProducts, 5, (variants_ids as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertIntoProducts, 6, CInt(tax_id))
        executeUpdate(sqlStatement: insertIntoProducts!)
    }
    
    func insertRanking(name:String)
    {
        if insertIntoRanking == nil
        {
            initializeStatement(sqlStatement: &insertIntoRanking, query: "INSERT INTO Ranking (name) VALUES (?)")
        }
        sqlite3_bind_text(insertIntoRanking, 1, (name as NSString).utf8String, -1, nil)
        executeUpdate(sqlStatement: insertIntoRanking!)
    }
    
    func insertRankingProduct(product_id:Int, view_count:String, order_count:String, shares_count:String)
    {
        if insertIntoRankingProduct == nil
        {
            initializeStatement(sqlStatement: &insertIntoRankingProduct, query: "INSERT INTO RankingProduct (product_id, view_count, order_count, shares_count) VALUES (?,?,?,?)")
        }
        sqlite3_bind_int(insertIntoRankingProduct, 1, CInt(product_id))
        sqlite3_bind_text(insertIntoRankingProduct, 2, (view_count as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoRankingProduct, 3, (order_count as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoRankingProduct, 4, (shares_count as NSString).utf8String, -1, nil)
        executeUpdate(sqlStatement: insertIntoRankingProduct!)
    }
    
    func insertTax(name:String, value:Double)
    {
        if insertIntoTax == nil
        {
            initializeStatement(sqlStatement: &insertIntoTax, query: "INSERT INTO Tax (name, value) VALUES (?,?)")
        }
        sqlite3_bind_text(insertIntoTax, 1, (name as NSString).utf8String, -1, nil)
        sqlite3_bind_double(insertIntoTax, 2, CDouble(value))
        executeUpdate(sqlStatement: insertIntoTax!)
    }
    
    func insertVariants(variant_id:Int, color:String, size:String , price:String)
    {
        if insertIntoVariants == nil
        {
            initializeStatement(sqlStatement: &insertIntoVariants, query: "INSERT INTO Variants (variant_id,color,size,price) VALUES (?,?,?,?)")
        }
        sqlite3_bind_int(insertIntoVariants, 1, CInt(variant_id))
        sqlite3_bind_text(insertIntoVariants, 2, (color as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoVariants, 3, (size as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertIntoVariants, 4, (price as NSString).utf8String, -1, nil)
        executeUpdate(sqlStatement: insertIntoVariants!)
    }
    
    func getTaxIdFor(name:String,value:Double)-> Int
    {

        if selectTaxId == nil
        {
            initializeStatement(sqlStatement: &selectTaxId, query: "SELECT tax_id FROM Tax WHERE name = ? and value = ?")
        }

        sqlite3_bind_text(selectTaxId, 1, (name as NSString).utf8String, -1, nil)
        sqlite3_bind_double(selectTaxId, 2, CDouble(value))

        var tax_id = 0
        while executeSelect(sqlStatement: selectTaxId!)
        {
            tax_id = Int(sqlite3_column_int(selectTaxId, 0))
        }
        sqlite3_reset(selectTaxId)
        return tax_id

    }

}
