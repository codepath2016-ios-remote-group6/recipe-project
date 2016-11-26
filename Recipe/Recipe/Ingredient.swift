//
//  Ingredient.swift
//  Recipe
//
//  Created by Iria on 11/13/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    var quantity: Float
    var unit: String
    var name: String
    
    override init() {
        quantity = 0
        unit = ""
        name = ""
        
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        quantity = dictionary["quantity"] as! Float
        unit = dictionary["units"] as! String
        name = dictionary["name"] as! String
    }
    
    class func IngredientsWithArray(dictionaries: [NSDictionary]) -> [Ingredient] {
        var ingredients = [Ingredient]()
        
        for dictionary in dictionaries {
            let ingredient = Ingredient(dictionary: dictionary)
            
            ingredients.append(ingredient)
        }
        
        return ingredients
    }
}
