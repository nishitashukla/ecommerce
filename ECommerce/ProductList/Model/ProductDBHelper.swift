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
    var selectParentCategories:OpaquePointer? = nil
    var selectSubCategory:OpaquePointer? = nil
    
    //Products Table Statements
    /*
     Table name : Products
     Columns : product_id Int PRIMARY KEY , name TEXT , dateAdded TEXT , category_id Int , variants_ids TEXT, tax_id int
     Note: Multiple variants will be saved comma seperated. Ex: 4,5,6
     */
    var createTableProducts:OpaquePointer? = nil
    var insertIntoProducts:OpaquePointer? = nil
    var selectAllProducts:OpaquePointer?=nil
    var selectCategoryWiseProducts:OpaquePointer?=nil
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
    var selectVariants:OpaquePointer?=nil
    
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
                initializeStatement(sqlStatement: &createTableCategories, query: "CREATE TABLE IF NOT EXISTS Categories(category_id INTEGER PRIMARY KEY, name TEXT,sub_category_ids TEXT)")
                executeUpdate(sqlStatement: createTableCategories!)
            }
            
            if createTableProducts == nil
            {
                initializeStatement(sqlStatement: &createTableProducts, query: "CREATE TABLE IF NOT EXISTS Products(product_id INTEGER PRIMARY KEY , name TEXT , dateAdded TEXT , category_id INTEGER , variants_ids TEXT, tax_id INTEGER)")
                executeUpdate(sqlStatement: createTableProducts!)
            }
            
            
            if createTableRanking == nil
            {
                initializeStatement(sqlStatement: &createTableRanking, query: "CREATE TABLE IF NOT EXISTS Ranking(ranking_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)")
                executeUpdate(sqlStatement: createTableRanking!)
            }
            
            
            if createTableRankingProduct == nil
            {
                initializeStatement(sqlStatement: &createTableRankingProduct, query: "CREATE TABLE IF NOT EXISTS RankingProduct(product_id INTEGER, view_count TEXT, order_count TEXT, shares_count TEXT)")
                executeUpdate(sqlStatement: createTableRankingProduct!)
            }
            
            
            if createTableTax == nil
            {
                initializeStatement(sqlStatement: &createTableTax, query: "CREATE TABLE IF NOT EXISTS Tax(tax_id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, value REAL)")
                executeUpdate(sqlStatement: createTableTax!)
            }
            
            
            if createTableVariants == nil
            {
                initializeStatement(sqlStatement: &createTableVariants, query: "CREATE TABLE IF NOT EXISTS Variants(variant_id INTEGER, color TEXT, size TEXT , price TEXT)")
                executeUpdate(sqlStatement: createTableVariants!)
            }
        }
    }
    
    //MARK: Insert Statments
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
    
    //MARK: Select Statements
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
    
    func getParentCategories()->[CategoryModel]
    {
        if(selectParentCategories == nil)
        {
            initializeStatement(sqlStatement: &selectParentCategories, query: "SELECT category_id,name,sub_category_ids FROM Categories WHERE sub_category_ids != ''")
        }
        var arrCategories:[CategoryModel] = []
        
        while executeSelect(sqlStatement: selectParentCategories!)
        {
            
            let category_id = Int(sqlite3_column_int(selectParentCategories, 0))
            let category_name =  String(cString: sqlite3_column_text(selectParentCategories, 1))
            let sub_category_ids = String(cString: sqlite3_column_text(selectParentCategories, 2))
            let sub_categories:[CategoryModel] = [CategoryModel]()
            
            let categoryModel = CategoryModel(category_id: category_id, category_name: category_name, sub_categories_ids: sub_category_ids,sub_categories:sub_categories)
            
            arrCategories.append(categoryModel)
            
        }
        sqlite3_reset(selectParentCategories)
        return arrCategories
    }
    
    func getChildCategories(sub_category_id : String)->[CategoryModel]
    {
        if(selectSubCategory == nil)
        {
            initializeStatement(sqlStatement: &selectSubCategory, query: "SELECT category_id,name,sub_category_ids FROM Categories WHERE category_id IN (\(sub_category_id))")
        }
        var arrCategories:[CategoryModel] = []
        
        while executeSelect(sqlStatement: selectSubCategory!)
        {
            
            let category_id = Int(sqlite3_column_int(selectSubCategory, 0))
            let category_name =  String(cString: sqlite3_column_text(selectSubCategory, 1))
            let sub_category_ids = String(cString: sqlite3_column_text(selectSubCategory, 2))
            let sub_categories:[CategoryModel] = [CategoryModel]()
            
            let categoryModel = CategoryModel(category_id: category_id, category_name: category_name, sub_categories_ids: sub_category_ids,sub_categories:sub_categories)
            
            arrCategories.append(categoryModel)
            
        }
        sqlite3_reset(selectSubCategory)

        return arrCategories
    }
    
    //Select p.product_id,p.name as product_name,p.dateAdded,p.category_id,c.name,p.variants_ids,t.name as tax_name,t.value from Products p
    //INNER JOIN Tax t ON t.tax_id == p.tax_id
    //INNER JOIN Categories c ON c.category_id = p.category_id
    
    
    func getAllProducts()->[ProductModel]
    {
        if(selectAllProducts == nil)
        {
            initializeStatement(sqlStatement: &selectAllProducts, query: "Select p.product_id,p.name as product_name,p.dateAdded,p.category_id,c.name as category_name,p.variants_ids,t.name as tax_name,t.value from Products p INNER JOIN Tax t ON t.tax_id == p.tax_id INNER JOIN Categories c ON c.category_id = p.category_id")
        }
        var arrProducts:[ProductModel] = []
        
        while executeSelect(sqlStatement: selectAllProducts!)
        {
            
            let product_id = Int(sqlite3_column_int(selectAllProducts, 0))
            let product_name =  String(cString: sqlite3_column_text(selectAllProducts, 1))
            let dateAdded = String(cString: sqlite3_column_text(selectAllProducts, 2))
            let category_id = Int(sqlite3_column_int(selectAllProducts, 3))
            let category_name = String(cString: sqlite3_column_text(selectAllProducts, 4))
            let variants_ids = String(cString: sqlite3_column_text(selectAllProducts, 5))
            let tax_name = String(cString: sqlite3_column_text(selectAllProducts, 6))
            let tax_value = sqlite3_column_double(selectAllProducts, 7)
            
            let variants = [VariantModel]()
            
            let productModel = ProductModel(product_id: product_id, product_name: product_name, dateAdded: dateAdded, category_id: category_id, category_name: category_name, variants_id: variants_ids, tax_value: tax_value, tax_name: tax_name,variants:variants)
            
            arrProducts.append(productModel)
            
        }
        sqlite3_reset(selectAllProducts)

        return arrProducts
    }
    
    func getProductVariants(variant_id : String)->[VariantModel]
    {
        print(variant_id)
        if(selectVariants == nil)
        {
            initializeStatement(sqlStatement: &selectVariants, query: "SELECT DISTINCT variant_id,color,size,price FROM Variants WHERE variant_id IN (\(variant_id))")
        }
        
        var arrVariants:[VariantModel] = []
        
        while executeSelect(sqlStatement: selectVariants!)
        {
            
            let variant_id = Int(sqlite3_column_int(selectVariants, 0))
            let color =  String(cString: sqlite3_column_text(selectVariants, 1))
            let size = String(cString: sqlite3_column_text(selectVariants, 2))
            let price = String(cString: sqlite3_column_text(selectVariants, 3))
            
            let variantModel = VariantModel(variant_id: variant_id, color: color, size: size, price: price)
            
            arrVariants.append(variantModel)
            
        }
        sqlite3_reset(selectVariants)
        selectVariants = nil
        return arrVariants
    }
    
}
