//
//  ParseTests.swift
//  Recipe
//
//  Created by Iria on 11/15/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import Foundation

func parseTest(){
    print("Starting Parse Test")
    
    let recipe: Recipe = Recipe()
    recipe.name = "Guacamole"
    recipe.summary = "Smooth avocado delight"
    recipe.prepTime = 20
    recipe.prepTimeUnits = "minutes"
    recipe.imageUrlString = "https://mylatinatable.com/wp-content/uploads/2016/02/guacamole-foto-heroe.jpg"
    
    var apples  = [String:AnyObject]()
    apples[Recipe.ingredientNameKey] = "Avocado" as AnyObject
    apples[Recipe.ingredientQuantityKey] = 2.0 as AnyObject
    apples[Recipe.ingredientUnitsKey] = "Avocados" as AnyObject
    
    var crust = [String:AnyObject]()
    crust[Recipe.ingredientNameKey] = "Onion" as AnyObject
    crust[Recipe.ingredientQuantityKey] = 0.5 as AnyObject
    crust[Recipe.ingredientUnitsKey] = "small onion" as AnyObject
    
    var ingredients: [Dictionary<String,AnyObject>] = Array<Dictionary<String,AnyObject>>()
    ingredients.append(apples)
    ingredients.append(crust)
    
    recipe.ingredients = ingredients
    
    print(recipe)
    
    recipe.saveInBackground(block: {(wasSuccessful: Bool, error: Error?)->Void in
        if let error = error{
            print("**********")
            print("save failed")
            print(error.localizedDescription)
        }else{
            print("**********")
            print("recipe saved successfully.")
            print("wasSuccessful: \(wasSuccessful) // error: \(error?.localizedDescription)")
        }
    })
    
}
