//
//  ingredientListEditCell.swift
//  Recipe
//
//  Created by Iria on 11/20/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class ingredientListEditCell: UITableViewCell {

    // Change these fields to spinners
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var ingredient: Ingredient? {
        didSet {
            quantityTextField.text = "\((ingredient?.quantity)!)"
            unitTextField.text = ingredient?.unit
            nameTextField.text = ingredient?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
