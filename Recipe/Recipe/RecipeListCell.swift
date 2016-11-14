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
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeSourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeImageView.layer.cornerRadius = 4
        recipeImageView.clipsToBounds = true
        // Initialization code
        
        self.accessoryType = UITableViewCellAccessoryType.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var recipe: Recipe?{
        willSet{
            self.recipeNameLabel.text = newValue?.name
            self.recipeSourceLabel.text = newValue?.inspiredBy
            if let url = newValue?.imageUrl{
                self.recipeImageView.setImageWith(url)
            }
        }
    }

}
