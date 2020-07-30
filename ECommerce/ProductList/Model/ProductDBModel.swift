//
//  ProductDBModel.swift
//  ECommerce
//
//  Created by Nishita Shukla on 30/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation

struct CategoryModel {
    
    let category_id : Int
    let category_name :String
    let sub_categories_ids :String
    let sub_categories:[CategoryModel]
}

struct ProductModel
{
    let product_id:Int
    let product_name:String
    let dateAdded:String
    let category_id:Int
    let category_name:String
    let variants_id:String
    let tax_value:Double
    let tax_name:String
    var variants:[VariantModel]
}

struct VariantModel {
    let variant_id:Int
    let color:String
    let size:String
    let price:String
}
