//
//  ProductViewController.swift
//  ECommerce
//
//  Created by Nishita Shukla on 28/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController
{
    
    //MARK: Variables
    
    lazy var productListViewModel:ProductsListViewModel = {
        return ProductsListViewModel()
    }()
    
    //MARK: Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: WebService Call
    func getProducts()
    {
        productListViewModel.getProductListData { (result) in
            switch result
            {
            case .success(_):
                print("API Complete")
            case .failure(let error):
                
                print(error.rawValue)
                
            }
        }
    }
    
    //MARK: Button Action
    
    @IBAction func btnCallAPI(_ sender: Any)
    {
        getProducts();
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
