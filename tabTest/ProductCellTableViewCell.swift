//
//  ProductCellTableViewCell.swift
//  tabTest
//
//  Created by Sergey Kozak on 07/01/2018.
//  Copyright © 2018 Centennial. All rights reserved.
//

import UIKit

class ProductCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
