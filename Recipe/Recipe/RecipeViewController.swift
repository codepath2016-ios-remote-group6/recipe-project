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
    
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var prepTimeUnitLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var ingredientTableViewHeightConstraint: NSLayoutConstraint!
    
    var recipe: Recipe!
    var ingredientsArray: [Ingredient]?
    var sourceType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsArray = Ingredient.IngredientsWithArray(dictionaries: recipe.ingredients as [NSDictionary])
        
//        if let urlString = recipe.imageUrlString{
//            if let url = URL(string: urlString){
//                recipeImageView.setImageWith(url)
//            }
//            
//            recipeImageView.layer.cornerRadius = 10
//            recipeImageView.clipsToBounds = true
//        } else {
//            recipeImageView.image = UIImage(named: "recipe-icon")
//        }
//        
//        recipeNameLabel.text = recipe.name
//        
//        difficultyLabel.text = recipe.getDifficulty()
//        
//        // Only display prep time if one is set.
//        if recipe.prepTime > 0 {
//            prepTimeLabel.text = "\(Int(recipe.prepTime))"
//            prepTimeUnitLabel.text = recipe.prepTimeUnits
//        } else {
//            prepTimeLabel.text = ""
//            prepTimeUnitLabel.text = ""
//        }
//        
//        // Show a link if we are looking at a recipe copied from the API, otherwise show the directions
//        if let inspiredByUrl = recipe.inspiredByUrl {
//            directionsTextView.text = "\(inspiredByUrl)"
//        } else {
//            directionsTextView.text = recipe.directionsString
//        }
        
        // This assumes there is always at least one ingredient
        let tableViewHeight = CGFloat(ingredientsTableView.rowHeight) * CGFloat((ingredientsArray?.count)!)
        
        ingredientTableViewHeightConstraint.constant = tableViewHeight
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.alwaysBounceVertical = false
        ingredientsTableView.allowsSelection = false
        ingredientsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        ingredientsTableView.rowHeight = UITableViewAutomaticDimension
        ingredientsTableView.estimatedRowHeight = 25.0
//        ingredientsTableView.reloadData()
        
        // Don't allow editing of a recipe from an external source
        if sourceType == "edamam" {
           editButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlString = recipe.imageUrlString{
            if let url = URL(string: urlString){
                recipeImageView.setImageWith(url)
            }
            
            recipeImageView.layer.cornerRadius = 10
            recipeImageView.clipsToBounds = true
        } else {
            recipeImageView.image = UIImage(named: "recipe-icon")
        }
        
        recipeNameLabel.text = recipe.name
        
        difficultyLabel.text = recipe.getDifficulty()
        
        // Only display prep time if one is set.
        if recipe.prepTime > 0 {
            prepTimeLabel.text = "\(Int(recipe.prepTime))"
            prepTimeUnitLabel.text = recipe.prepTimeUnits
        } else {
            prepTimeLabel.text = ""
            prepTimeUnitLabel.text = ""
        }
        
        // Show a link if we are looking at a recipe copied from the API, otherwise show the directions
        if let inspiredByUrl = recipe.inspiredByUrl {
            directionsTextView.text = "\(inspiredByUrl)"
        } else {
            directionsTextView.text = recipe.directionsString
        }
        
        ingredientsTableView.reloadData()
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
        
//        let ingredient = ingredientsArray?[indexPath.row]
        let ingredient = recipe.ingredientObjList[indexPath.row]
        
        cell.quantityLabel.text = "\((ingredient.quantity))"
        cell.unitLabel.text = ingredient.unit
        cell.nameLabel.text = ingredient.name
        
        cell.alternativeTextLabel.text = ingredient.alternativeText
        
        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("segue identifier \(segue.identifier)")
        let destinationVc = segue.destination
        var recipeForNextVc: Recipe!
        if let identifier = segue.identifier{
            if identifier == "editSegue"{
                recipeForNextVc = self.recipe
            }else{
                recipeForNextVc = self.recipe.getCopy()
            }
        }
        if let recipeEditVc = destinationVc as? RecipeEditViewController{
//            recipeEditVc.recipe = recipeForNextVc
            recipeEditVc.setRecipe(recipe: recipeForNextVc)
        }
    }
}
