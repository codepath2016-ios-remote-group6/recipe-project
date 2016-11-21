//
//  AddIngredientListCell.swift
//  Recipe
//
//  Created by Pallavi Kurhade Methe on 11/19/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class AddIngredientListCell: UITableViewCell {

    @IBOutlet weak var IngredientDetailsPickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
