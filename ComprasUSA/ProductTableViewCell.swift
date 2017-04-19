//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Heitor Souza on 4/18/17.
//  Copyright © 2017 RafaelHeitor. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
