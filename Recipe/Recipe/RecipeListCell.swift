//
//  RecipeListCell.swift
//  Recipe
//
//  Created by Iria on 11/12/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeListCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
