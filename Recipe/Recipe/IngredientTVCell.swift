//
//  IngredientTVCell.swift
//  Recipe
//
//  Created by Craig Vargas on 12/6/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class IngredientTVCell: UITableViewCell {
    
    public static let name = "IngredientTVCell"
    
    @IBOutlet weak var bulletView: UIView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: Ingredient?{
        didSet{
            ingredientLabel.text = ingredient?.alternativeText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bulletView.layer.cornerRadius = 2.5
        bulletView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
