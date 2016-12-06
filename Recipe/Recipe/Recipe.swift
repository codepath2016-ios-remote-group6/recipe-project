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
    static let ingredientAuxTextKey = "auxText"
    static let ingredientAltTextKey = "auxText"
    
    static let directionOrderNumKey = "orderNumber"
    static let directionDescriptionKey = "directionDescription"
    
    static let className = "Recipe"
    
    static let createdByUserKey = "createdByUser"
    
    static let difficultyMap = ["Very easy", "Easy", "Medium", "Hard", "Very hard"]
    
    //properties
    @NSManaged var name: String?
    @NSManaged var imageUrlString: String?
    @NSManaged var imageFile: PFFile?
    @NSManaged var createdByUser: PFUser?
    @NSManaged var inspiredBy: String?
//    @NSManaged var inspiredByUrlString: String?
    @NSManaged var inspiredByRecipeUrlString: String?
    @NSManaged var sourceId: String?
    @NSManaged var summary: String?
//    @NSManaged var prepTimeStr: String?
    @NSManaged var prepTime: Double
    @NSManaged var prepTimeUnits: String?
    @NSManaged var difficulty: Int
    @NSManaged var ingredients: [Dictionary<String,AnyObject>]
//    @NSManaged var ingredientList: [String]?
//    @NSManaged var directionsDict: [String]?
//    @NSManaged var directions: [String]?
    @NSManaged var directionsString: String?
    
    //Properties that do not get saved to the database
    var imageUrl: URL?{
        get{
            return Recipe.getUrl(fromOptionalString: imageUrlString)
        }
    }
    var inspiredByRecipeUrl: URL?{
        get{
            return Recipe.getUrl(fromOptionalString: inspiredByRecipeUrlString)
        }
    }
    var ingredientObjList: [Ingredient] = [Ingredient]()
    
    enum SourceType: String {
        case edamam = "edamam"
        case database = "database"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(dictionary: NSDictionary) {
        self.init()
        
        createdByUser = PFUser.current()
        
        name = dictionary["name"] as? String
        prepTime = (dictionary["prepTime"] as! NSString).doubleValue
        prepTimeUnits = dictionary["prepTimeUnits"] as? String
        
        difficulty = (dictionary["difficulty"] as! NSString).integerValue
        
        // Temporary fix. store directions as one element in the array until we can decide on a standard form for the directions
        if let dictionaryDirections = dictionary["directions"] as? String {
            directionsString = dictionaryDirections
        }
        
        
        // TODO see if we can change this to automatically convert to Ingredient class
        var dictionaryIngredients = [Dictionary<String, AnyObject>]()
        
        for ingredient in (dictionary["ingredients"] as? [Dictionary<String, AnyObject>])! {
            var normalizedIngredient = ingredient
            
            normalizedIngredient["quantity"] = (ingredient["quantity"] as! NSString).doubleValue as AnyObject?
            
            dictionaryIngredients.append(normalizedIngredient)
            
            let ingredientObject = Ingredient(dictionary: normalizedIngredient as NSDictionary)
            ingredientObjList.append(ingredientObject)
        }
        
        ingredients = dictionaryIngredients        
    }
    
    static func parseClassName() -> String {
        return "Recipe"
    }
    
    func saveToDb() {
        if createdByUser == nil {
            createdByUser = PFUser.current()
        }
        if inspiredBy == nil{
            inspiredBy = ""
        }
        
        self.saveInBackground(block: {(wasSuccessful: Bool, error: Error?)->Void in
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
    
    func deleteFromDb() {
        self.deleteInBackground(block: {(wasSuccessful: Bool, error: Error?)->Void in
            if let error = error{
                print("**********")
                print("delete failed")
                print(error.localizedDescription)
            }else{
                print("**********")
                print("recipe deleted successfully.")
                print("wasSuccessful: \(wasSuccessful) // error: \(error?.localizedDescription)")
            }
        })
    }
    
    //Build recipe with Edamam dictionary
    class func recipe(fromEdamamDict dictionary: Dictionary<String,Any>) -> Recipe{
        let recipe = Recipe()
        if let recipeDict = dictionary["recipe"] as? Dictionary<String,Any>{
            recipe.name = recipeDict["label"] as? String
            recipe.inspiredBy = recipeDict["source"] as? String
            recipe.inspiredByRecipeUrlString = recipeDict["shareAs"] as? String
            recipe.sourceId = recipeDict["uri"] as? String
            recipe.imageUrlString = recipeDict["image"] as? String
            
            //TODO work on ingredient list next
            if let ingredientDictList = recipeDict["ingredients"] as? [Dictionary<String,Any>]{
                recipe.ingredients = [Dictionary<String,AnyObject>]()
                var ingredient = Dictionary<String,AnyObject>()
                for ingredientDict in ingredientDictList{
                    ingredient[self.ingredientNameKey] = ingredientDict["food"] as AnyObject
                    ingredient[self.ingredientQuantityKey] = ingredientDict["quantity"] as AnyObject
                    ingredient[self.ingredientUnitsKey] = ingredientDict["measure"] as AnyObject
                    ingredient[self.ingredientAuxTextKey] = ingredientDict["text"] as AnyObject
                    recipe.ingredients.append(ingredient)
                    
                    let ingredientObject = Ingredient(dictionary: ingredient as NSDictionary)
                    recipe.ingredientObjList.append(ingredientObject)
                }
            }
        }
        return recipe
    }
    
    //Search Edamam with query
    class func searchEdamam(forRecipesWithQuery query: String?, startIndex: Int?, numResults: Int?, success: @escaping ([Dictionary<String,Any>])->(), failure: @escaping (Error?)->()){
        EdamamClient.search(
            query: query,
            startIndex: startIndex,
            numResults: numResults,
            recipeUri: nil,
            success: {(recipeList: [Dictionary<String,Any>])->Void in
                success(recipeList)},
            failure: {(error: Error?)->Void in
                failure(error)})
    }
    
    //Search Edamam with recipeUri
    class func searchEdamam(forRecipeWith recipeUri: String, success: @escaping ([Dictionary<String,Any>])->(), failure: @escaping (Error?)->()){
        EdamamClient.search(
            query: nil,
            startIndex: nil,
            numResults: nil,
            recipeUri: recipeUri,
            success: {(recipeList: [Dictionary<String,Any>])->Void in
                success(recipeList)},
            failure: {(error: Error?)->Void in
                failure(error)})
    }
    
    class func recipes(withEdamamRecipeDictList recipeDictList: [Dictionary<String,Any>])->[Recipe]{
        var recipes = [Recipe]()
        for recipeDict in recipeDictList{
            recipes.append(Recipe.recipe(fromEdamamDict: recipeDict))
        }
        return recipes
    }
    
    class func getUrl(fromOptionalString optUrlString: String?)->URL?{
        if let urlString = optUrlString{
            return URL(string: urlString)
        }else{
            return nil
        }
    }
    
    // Returns the difficulty mapped to a readable string
    func getDifficulty() -> String {
        return 1...5 ~= self.difficulty ? Recipe.difficultyMap[self.difficulty - 1] : ""
    }
    
    class func getDefaultRecipeList() -> [Recipe] {
        var recipeList = [Recipe]();
        
        if let path = Bundle.main.path(forResource: "default_recipes", ofType: "json")
        {
            let jsonData = try! NSData(contentsOfFile: path, options: .dataReadingMapped)
            
            let recipeArray: NSArray = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
            
            for item in recipeArray {
                let dictionary = item as! NSDictionary
                let recipe = Recipe(dictionary: dictionary)
                
                recipeList.append(recipe)
            }
            
        }
        
        return recipeList;
    }
    
    class func getMyRecipes(success: @escaping ([Recipe])->(), failure: @escaping (Error?)->()){
        if let currentUser = PFUser.current(){
            print("currentUser: \(currentUser)")
            let query = PFQuery(className: Recipe.className)
            query.whereKey(Recipe.createdByUserKey, equalTo: currentUser)
            query.findObjectsInBackground(block: {(results: [PFObject]?, error: Error?)->Void in
                if error == nil{
                    //successful query
                    print("found 'MyRecipes' successfully in parse DB")
                    var recipes = [Recipe]()
                    if let results = results{
                        for result in results{
                            if let recipe = result as? Recipe{
                                recipe.buildIngredientObjectsList()
                                recipes.append(recipe)
                            }
                        }
                        success(recipes)
                    }
                }else{
                    failure(error)
                }
            })
        }else{
            User.login()
        }
    }
    
    class func getRecipesFromDb(success: @escaping ([Recipe])->(), failure: @escaping (Error?)->()){
        let query = PFQuery(className: Recipe.className)
        query.findObjectsInBackground(block: {(results: [PFObject]?, error: Error?)->Void in
            if error == nil{
                //successful query
                print("found 'MyRecipes' successfully in parse DB")
                var recipes = [Recipe]()
                if let results = results{
                    for result in results{
                        if let recipe = result as? Recipe{
                            recipe.buildIngredientObjectsList()
                            recipes.append(recipe)
                        }
                    }
                    success(recipes)
                }
            }else{
                failure(error)
            }
        })
    }
    
    func buildIngredientObjectsList(){
        ingredientObjList = Ingredient.IngredientsWithArray(dictionaries: ingredients as [NSDictionary])
    }
    
    func prepareIngredientsForDbStorage(){
        var tempIngredientObjList = Array<Ingredient>()
        for ingredient in ingredientObjList{
            if shouldSave(ingredient: ingredient){
                tempIngredientObjList.append(ingredient)
            }
        }
        ingredientObjList = tempIngredientObjList
        ingredients = Ingredient.IngredientDictionariesWithArray(ingredients: ingredientObjList)
    }
    
    func shouldSave(ingredient: Ingredient)->Bool{
        return ingredient.name != Ingredient.newIngredientName && (ingredient.name != "" || ingredient.alternativeText != "")
    }
    
    func getCopy() -> Recipe{
        let copy = Recipe()
        
        if let name = name{
            copy.name = name
        }
        if let imageUrlString = imageUrlString{
            copy.imageUrlString = imageUrlString
        }
        if let imageFile = imageFile{
            copy.imageFile = imageFile
        }
        if let inspiredBy = inspiredBy{
            copy.inspiredBy = inspiredBy
        }
        if let inspiredByRecipeUrlString = inspiredByRecipeUrlString{
            copy.inspiredByRecipeUrlString = inspiredByRecipeUrlString
        }
        if let sourceId = sourceId{
            copy.sourceId = sourceId
        }
        if let summary = summary{
            copy.summary = summary
        }
        copy.prepTime = prepTime
        if let prepTimeUnits = prepTimeUnits{
            copy.prepTimeUnits = prepTimeUnits
        }
        copy.difficulty = difficulty
        copy.ingredients = ingredients
//        if let directions = directions{
//            copy.directions = directions
//        }
        if let directionsString = directionsString{
            copy.directionsString = directionsString
        }
        copy.ingredientObjList = Ingredient.IngredientsWithArray(dictionaries: ingredients as [NSDictionary])
        
        return copy
    }
    
    //For debugging purposes
    func printIngredientDictList(){
        print("Ingredients Dict:")
        for ingredient in ingredients{
            print(ingredient)
        }
    }
    
    //For debugging purposes
    func printIngredientObjecList(){
        print("Ingredients Object List:")
        for ingredient in ingredientObjList{
            let ingredientString = ingredient.name + ", " + ingredient.unit + ", " + String(ingredient.quantity) + ", " + ingredient.alternativeText
            print(ingredientString)
        }
    }
    
    func setImageIn(imageView: UIImageView, placeholder: UIImage){
        if let imageFile = imageFile{
            imageFile.getDataInBackground(block: {(imageData: Data?, error: Error?)->Void in
                if error == nil{
                    if let imageData = imageData{
                        imageView.image = UIImage(data: imageData)
                    }
                }else{
                    print("Error getting data from image file: \(error!.localizedDescription)")
                }})
        }else if let imageUrl = imageUrl{
            imageView.setImageWith(imageUrl, placeholderImage: placeholder)
        }else{
            imageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }

}
