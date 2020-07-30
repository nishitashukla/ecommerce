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
    
    lazy var dbHelper:ProductDBHelper = {
        return ProductDBHelper.sharedInstance()
    }()
    
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
                self.processFetchedCategories(products: products.categories)
                self.processFetchedRankings(rankings:products.rankings)
                completionHandler(.success(products))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func processFetchedCategories( products: [Category] )
    {
        var uniqueTax = [Tax]()
        for category in products
        {
            let category_id = category.id
            let category_name = category.name
            let sub_categories = (category.childCategories.map{String($0)}).joined(separator: ",")
            
            dbHelper.insertCategories(category_id: category_id, name: category_name, sub_category_ids: sub_categories)
            
            if(sub_categories.count == 0)
            {
                for products in category.products
                {
                    let contains = uniqueTax.contains(where: { $0.value == products.tax.value})
                    if(!contains)
                    {
                        dbHelper.insertTax(name: products.tax.name.rawValue, value: products.tax.value)
                        uniqueTax.append(products.tax)
                    }
                    let variants_id = products.variants.map{
                        String($0.id)}.joined(separator: ",")
                    let tax_id = dbHelper.getTaxIdFor(name: products.tax.name.rawValue, value: products.tax.value)
                    
                    dbHelper.insertProducts(product_id: products.id, name: products.name, dateAdded: products.dateAdded, category_id: category.id, variants_ids: variants_id, tax_id: tax_id)
                    
                    for variants in products.variants
                    {
                        var size = 0
                        if let tempSize = variants.size
                        {
                            size = tempSize
                        }
                        dbHelper.insertVariants(variant_id: variants.id, color: variants.color, size: "\(String(describing: size))" , price: "\(variants.price)")
                    }
                }
            }
        }
    }
    
    private func processFetchedRankings(rankings:[Ranking])
    {
        var arrRankingProduct = [RankingProduct]()
        
        for ranking in rankings
        {
            dbHelper.insertRanking(name: ranking.ranking)
            arrRankingProduct.append(contentsOf: ranking.products)
        }
        

        let dict = Dictionary(grouping: arrRankingProduct, by: { $0.id })
        for rankingProducts in dict.values
        {
            var view_count = 0
            var order_count = 0
            var share_count = 0
            var product_id = 0
            for rankingProduct in rankingProducts
            {
                product_id = rankingProduct.id
                if let views = rankingProduct.viewCount
                {
                    view_count = views
                }
                 
                if let orders = rankingProduct.orderCount
                {
                    order_count = orders
                }
                
                if let shares = rankingProduct.shares
                {
                    share_count = shares
                }
            }
                        
            dbHelper.insertRankingProduct(
                               product_id:product_id,
                               view_count:"\(String(describing: view_count))",
                               order_count:"\(String(describing: order_count))",
                               shares_count:"\(String(describing: share_count))")
        }
    }
}

