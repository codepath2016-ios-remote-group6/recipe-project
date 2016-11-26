//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var directionsTextView: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var prepTimeUnitLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    var recipe: Recipe!
    var ingredientsArray: [Ingredient]?
    var sourceType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsArray = Ingredient.IngredientsWithArray(dictionaries: recipe.ingredients as [NSDictionary])
        
        // This assumes there is always at least one ingredient
//        let tableViewHeight = ingredientsTableView.rowHeight as Int * (ingredientsArray?.count)!
        
        if let urlString = recipe.imageUrlString{
            if let url = URL(string: urlString){
                recipeImageView.setImageWith(url)
            }
            
            recipeImageView.layer.cornerRadius = 10
            recipeImageView.clipsToBounds = true
        }
        
//        else {
//            recipeImageView.removeFromSuperview()
//            recipeImageView = nil
//        }
        
        recipeNameLabel.text = recipe.name
        
        prepTimeLabel.text = "\(recipe.prepTime)"
        prepTimeUnitLabel.text = recipe.prepTimeUnits
        
        if let inspiredByUrl = recipe.inspiredByUrl {
            directionsTextView.text = "\(inspiredByUrl)"
        } else {
            directionsTextView.text = recipe.directions?[0]
        }
        
//        ingredientsTableView.size.height = tableViewHeight
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.alwaysBounceVertical = false
        ingredientsTableView.allowsSelection = false
        ingredientsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        ingredientsTableView.reloadData()
        
        
        // Don't allow editing of a recipe from an external source
        if sourceType == "edamam" {
           editButton.isHidden = true
        }
        
        //Refresh Recipe
//        refreshRecipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToRecipeList", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "IngredientListCell", for: indexPath) as! IngredientListCell
        
        let ingredient = ingredientsArray?[indexPath.row]
        
        cell.quantityLabel.text = "\((ingredient?.quantity)!)"
        cell.unitLabel.text = ingredient?.unit
        cell.nameLabel.text = ingredient?.name
        
        return cell
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshRecipe(){
        if let id = self.recipe.sourceId{
        Recipe.recipe(
            fromFoodToForkApiRequestWith: id,
            success: {(recipeDict: Dictionary<String,Any>)->Void in
                self.recipe = Recipe.recipe(fromFoodToForkDict: recipeDict)
                print("***********")
                print("refreshed Recipe: \(self.recipe)")},
            failure: {(error: Error?)->Void in
                print(error?.localizedDescription)})
        }else{
            print("Error getting recipeId")
        }
    }

}
