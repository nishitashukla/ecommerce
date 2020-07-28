//
//  ProductListClient.swift
//  ECommerce
//
//  Created by Nishita Shukla on 28/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation

struct ProductListClient
{
    
    //Dependecy Injection
    var httpClient : HTTPClient
    
    init(_httpClient: HTTPClient)
    {
        httpClient = _httpClient
    }
    
}

extension ProductListClient : ProductsListProtocol
{
    
    //MARK: Get Products List

    func getProductList(url:String , data:[String:String], completionHandler:@escaping (Result<ProductsModel, APIError>) -> ())
    {
        httpClient.callWebService(requestUrl: url, dataToSend: data, requestType: APIRequestType.APIRequestTypeGet, resultType: ProductsModel.self) { result in
            
            switch result
            {
            case .success(let product):
                completionHandler(.success(product))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
    }
}
