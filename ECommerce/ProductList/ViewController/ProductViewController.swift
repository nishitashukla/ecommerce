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
    
    @IBOutlet weak var tblProducts: UITableView!
    lazy var productListViewModel:ProductsListViewModel = {
        return ProductsListViewModel()
    }()
    
    //MARK: Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       getProducts()
        
        self.tblProducts.isHidden = true
    }
    
    //MARK: WebService Call
    func getProducts()
    {
        productListViewModel.getProductListData { (result) in
            switch result
            {
            case .success(_):
                print("API Complete")
                DispatchQueue.main.async {
                    self.tblProducts.isHidden = false
                    self.tblProducts.delegate = self;
                    self.tblProducts.dataSource = self;
                    self.tblProducts.reloadData()
                }
            case .failure(let error):
                
                print(error.rawValue)
                
            }
        }
    }
}

extension ProductViewController:UITableViewDelegate,UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productListViewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productListViewModel.getTitleForRowAtSection(at: section)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productListViewModel.getNumberofRowsInSection(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblProducts.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let cellModel = productListViewModel.getCellViewModel(at: indexPath)
        cell.productListCellModel = cellModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
    
}
