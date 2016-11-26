//
//  Ingredient.swift
//  Recipe
//
//  Created by Iria on 11/13/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class Ingredient: NSObject {
    var quantity: Double
    var unit: String
    var name: String
    var alternativeText: String
    
    init(dictionary: NSDictionary) {
        quantity = dictionary["quantity"] as? Double ?? 0
        unit = dictionary["units"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        alternativeText = dictionary[Recipe.ingredientAltTextKey] as? String ?? ""
        
        if alternativeText == ""{
            print("Ingredient: making alt text since dict value = \(dictionary[Recipe.ingredientAltTextKey])")
//            alternativeText = String(quantity) + " " + unit + " of " + name
            alternativeText = Ingredient.makeAlternativeText(quantity: quantity, units: unit, name: name)
        }
    }
    
    override init(){
        quantity = 0
        unit = ""
        name = ""
        alternativeText = ""
    }

    func makeDictionary() -> Dictionary<String,AnyObject>{
        var dict = Dictionary<String,AnyObject>()
        if name != ""{
            dict[Recipe.ingredientNameKey] = name as AnyObject
        }
        if unit != ""{
            dict[Recipe.ingredientUnitsKey] = unit as AnyObject
        }
        if alternativeText != ""{
            dict[Recipe.ingredientAltTextKey] = alternativeText as AnyObject
        }
        dict[Recipe.ingredientQuantityKey] = quantity as AnyObject
        
        return dict
    }
    
    class func IngredientsWithArray(dictionaries: [NSDictionary]) -> [Ingredient] {
        var ingredients = [Ingredient]()
        
        for dictionary in dictionaries {
            let ingredient = Ingredient(dictionary: dictionary)
            
            ingredients.append(ingredient)
        }
        
        return ingredients
    }
    
    class func IngredientDictionariesWithArray(ingredients: [Ingredient]) -> [Dictionary<String,AnyObject>]{
        var dictionaries = [Dictionary<String,AnyObject>]()
        for ingredient in ingredients{
            dictionaries.append(ingredient.makeDictionary())
        }
        return dictionaries
    }
    
    func setProperties(with dictionary: Dictionary<String,AnyObject>){
        quantity = dictionary["quantity"] as? Double ?? 0
        unit = dictionary["units"] as? String ?? ""
        name = dictionary["name"] as? String ?? ""
        alternativeText = dictionary[Recipe.ingredientAltTextKey] as? String ?? ""
        
        if alternativeText == ""{
            alternativeText = String(quantity) + " " + unit + " of " + name
        }
    }
    
    class func makeAlternativeText(quantity: Double, units: String?, name: String?) -> String{
        return String(quantity) + " " + (units ?? "") + " of " + (name ?? "")
    }
    
    func makeAlternativeText() -> String{
        return Ingredient.makeAlternativeText(quantity: quantity, units: unit, name: name)
    }
    
    func alternativeTextIsUnique() -> Bool{
        return alternativeText != makeAlternativeText()
    }
}
