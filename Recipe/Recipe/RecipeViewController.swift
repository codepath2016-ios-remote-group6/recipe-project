//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dummy data
        let recipe: Recipe = Recipe()
        recipe.name = "Apple Pie"
        recipe.summary = "Delicious desert"
        recipe.prepTime = 1.5
        recipe.prepTimeUnits = "hours"
        
        var apples  = [String:AnyObject]()
        apples[Recipe.ingredientNameKey] = "apples" as AnyObject
        apples[Recipe.ingredientQuantityKey] = 2.0 as AnyObject
        apples[Recipe.ingredientUnitsKey] = "lbs" as AnyObject
        
        var crust = [String:AnyObject]()
        crust[Recipe.ingredientNameKey] = "pie crust" as AnyObject
        crust[Recipe.ingredientQuantityKey] = 1.0 as AnyObject
        crust[Recipe.ingredientUnitsKey] = "none" as AnyObject
        
        var ingredients: [Dictionary<String,AnyObject>] = Array<Dictionary<String,AnyObject>>()
        ingredients.append(apples)
        ingredients.append(crust)
        
        recipe.ingredients = ingredients

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
