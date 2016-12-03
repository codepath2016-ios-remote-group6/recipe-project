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
    
    var recipe: Recipe?{
        willSet{
            self.recipeNameLabel.text = newValue?.name
            self.recipeSourceLabel.text = newValue?.inspiredBy
            newValue?.setImageIn(imageView: recipeImageView, placeholder: #imageLiteral(resourceName: "placeholder"))
            //CV: @Iria I commented out the lines below to instead use the helper function above that accomodates imageFiles
//            if let url = newValue?.imageUrl{
//                self.recipeImageView.setImageWith(url)
//            } else if let urlString = newValue?.imageUrlString{
//                if let url = URL(string: urlString){
//                    self.recipeImageView.setImageWith(url)
//                }
//            } else {
//                // Use a default icon if there is no image.
//                recipeImageView.image = UIImage(named: "recipe-icon")
//            }
        }
    }
    
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
}
