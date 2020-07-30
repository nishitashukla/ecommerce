//
//  ProductCell.swift
//  ECommerce
//
//  Created by Nishita Shukla on 30/07/20.
//  Copyright © 2020 Nishita Shukla. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell
{
    
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var sizeStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: Set data in the cell
    var productListCellModel : ProductListCellModel? {
        didSet {
            
            sizeStackView.isHidden = true
            if(productListCellModel?.size != "0")
            {
                lblSize.text = productListCellModel?.size
                sizeStackView.isHidden = false
            }
            lblColor.text = productListCellModel?.color
            
            if let price = productListCellModel?.price
            {
                lblPrice.text = "₹\(price)"
            }
            else
            {
                lblPrice.text = "Free"
                
            }
            
        }
    }
    
}
