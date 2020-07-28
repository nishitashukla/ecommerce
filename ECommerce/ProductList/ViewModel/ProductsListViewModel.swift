//
//  ProductsListViewModel.swift
//  ECommerce
//
//  Created by Nishita Shukla on 28/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import Foundation

class ProductsListViewModel
{
    //MARK: Variables

    var productListClient : ProductsListProtocol
    
    //MARK: Initialize Product Client
    init( _productListClient: ProductsListProtocol = ProductListClient(_httpClient: HTTPClient()))
    {
        self.productListClient = _productListClient
    }
    
    //MARK: Get Product List ---> GET Method
    func getProductListData(completionHandler:@escaping (Result<ProductsModel, APIError>) -> ())
    {
        productListClient.getProductList(url: URLConstants.BASEURL, data: [:]) { (result) in
            switch result
            {
            case .success(let products):
                self.processFetchedProducts(products: products)
                completionHandler(.success(products))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func processFetchedProducts( products: ProductsModel )
    {
        print(products.rankings)
    }
}
