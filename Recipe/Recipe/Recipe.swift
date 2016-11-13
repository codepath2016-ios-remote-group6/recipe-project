//
//  Recipe.swift
//  Recipe
//
//  Created by Craig Vargas on 11/9/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class Recipe : PFObject, PFSubclassing {

    static let ingredientNameKey = "name"
    static let ingredientQuantityKey = "quantity"
    static let ingredientUnitsKey = "units"
    
    //properties
    @NSManaged var name: String
    @NSManaged var createdBy: PFRelation<PFUser>
    @NSManaged var summary: String
    @NSManaged var prepTimeStr: String
    @NSManaged var prepTime: Double
    @NSManaged var prepTimeUnits: String
    @NSManaged var difficulty: Int
    @NSManaged var ingredients: [Dictionary<String,AnyObject>]
    
    func create(ingredientObjectWith name: String, quantity: Double, units: String)->Dictionary<String,AnyObject>{
        var ingredient = [String:AnyObject]()
        ingredient[Recipe.ingredientNameKey] = name as AnyObject
        ingredient[Recipe.ingredientQuantityKey] = quantity as AnyObject
        ingredient[Recipe.ingredientUnitsKey] = units as AnyObject
        return ingredient
    }
    
    static func parseClassName() -> String {
        return "Recipe"
    }
}
