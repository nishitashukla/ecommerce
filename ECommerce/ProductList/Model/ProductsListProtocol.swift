//
//  ProductsListProtocol.swift
//  ECommerce
//
//  Created by Nishita Shukla on 29/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation

protocol ProductsListProtocol
{
     func getProductList(url:String , data:[String:String], completionHandler:@escaping (Result<ProductsModel, APIError>) -> ())
}
