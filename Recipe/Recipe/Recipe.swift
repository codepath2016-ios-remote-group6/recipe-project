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
    
    static let directionOrderNumKey = "orderNumber"
    static let directionDescriptionKey = "directionDescription"
    
    //properties
    @NSManaged var name: String?
    @NSManaged var imageUrlString: String?
    @NSManaged var imageFile: PFFile?
    @NSManaged var createdByUser: PFRelation<PFUser>?
    @NSManaged var inspiredBy: String?
    @NSManaged var inspiredByUrlString: String?
    @NSManaged var inspiredByRecipeUrlString: String?
    @NSManaged var sourceId: String?
    @NSManaged var summary: String?
    @NSManaged var prepTimeStr: String?
    @NSManaged var prepTime: Double
    @NSManaged var prepTimeUnits: String?
    @NSManaged var difficulty: Int
    @NSManaged var ingredients: [Dictionary<String,AnyObject>]
    @NSManaged var ingredientList: [String]?
    @NSManaged var directionsDict: [Dictionary<Int,String>]?
    @NSManaged var directions: [String]?
    
    var imageUrl: URL?
    var inspiredByUrl: URL?
    var inspiredByRecipeUrl: URL?
    
    func create(ingredientObjectWith name: String, quantity: Double, units: String)->Dictionary<String,AnyObject>{
        var ingredient = [String:AnyObject]()
        ingredient[Recipe.ingredientNameKey] = name as AnyObject
        ingredient[Recipe.ingredientQuantityKey] = quantity as AnyObject
        ingredient[Recipe.ingredientUnitsKey] = units as AnyObject
        return ingredient
    }
    
    func create(directionObjectWith orderNumber: Int, description: String)->Dictionary<String,AnyObject>{
        var direction = [String:AnyObject]()
        direction[Recipe.directionOrderNumKey] = orderNumber as AnyObject
        direction[Recipe.directionDescriptionKey] = description as AnyObject
        return direction
    }
    
    static func parseClassName() -> String {
        return "Recipe"
    }
    
    class func recipe(fromFoodToForkDict dictionary: Dictionary<String,Any>) -> Recipe{
        let recipe = Recipe()
        recipe.name = dictionary["title"] as? String
        recipe.inspiredBy = dictionary["publisher"] as? String
        recipe.inspiredByUrlString = dictionary["publisher_url"] as? String
        recipe.inspiredByRecipeUrlString = dictionary["source_url"] as? String
        recipe.sourceId = dictionary["recipe_id"] as? String
        recipe.imageUrlString = dictionary["image_url"] as? String
        recipe.ingredientList = dictionary["ingredients"] as? [String]
        recipe.ingredients = [Dictionary<String,AnyObject>]()
        
        //populateUrls
        recipe.inspiredByUrl = recipe.getUrl(fromOptionalString: recipe.inspiredByUrlString)
        recipe.inspiredByRecipeUrl = recipe.getUrl(fromOptionalString: recipe.inspiredByRecipeUrlString)
        recipe.imageUrl = recipe.getUrl(fromOptionalString: recipe.imageUrlString)
        
        return recipe
    }
    
    class func recipe(fromFoodToForkApiRequestWith recipeId: String, success: @escaping (Dictionary<String,Any>)->(), failure: @escaping (Error?)->()){
        FoodToForkClient.getRecpie(withRecipeId: recipeId,
            success: {(recipe: Dictionary<String,Any>)->Void in
                success(recipe)},
            failure: {(error: Error?)->Void in
                failure(error)})
    }
    
    class func searchFoodToFork(query: String?, page: String?, sort: String?, success: @escaping ([Dictionary<String,Any>])->(), failure: @escaping (Error?)->()){
        FoodToForkClient.search(
            query: query,
            page: page,
            sort: sort,
            success: {(recipeList: [Dictionary<String,Any>])->Void in
                success(recipeList)},
            failure: {(error: Error?)->Void in
                failure(error)})
    }
    
    class func recipes(recipeDictList: [Dictionary<String,Any>])->[Recipe]{
        var recipes = [Recipe]()
        for recipeDict in recipeDictList{
            recipes.append(Recipe.recipe(fromFoodToForkDict: recipeDict))
        }
        return recipes
    }
    
    func getUrl(fromOptionalString optUrlString: String?)->URL?{
        if let urlString = optUrlString{
            return URL(string: urlString)
        }else{
            return nil
        }
    }
    
}
