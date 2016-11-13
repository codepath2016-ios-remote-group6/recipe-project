//
//  IngredientListCell.swift
//  Recipe
//
//  Created by Iria on 11/13/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class IngredientListCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
