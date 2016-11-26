//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi Kurhade on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse

class RecipeEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipe: Recipe!
    var sourceAction: String?
    var ingredientsArray = [Ingredient]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if recipe == nil {
            recipe = Recipe()
        }
        
        nameTextField.text = recipe.name
        directionsTextView.text = (recipe.directions != nil) ? recipe.directions![0] : ""
            
        ingredientsArray = Ingredient.IngredientsWithArray(dictionaries: recipe.ingredients as [NSDictionary])
        
        if ingredientsArray.count == 0 {
            ingredientsArray.append(Ingredient())
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientListCell", for: indexPath) as! AddIngredientListCell
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientListEditCell") as! ingredientListEditCell
        
        cell.ingredient = ingredientsArray[indexPath.row]
        
        return cell
    }
    
    @IBAction func onDoneButton(_ sender: AnyObject) {
        recipe.name = nameTextField.text
        
        // Temporary workaround while we figure out what to do with how directions are saved
        recipe.directions = [directionsTextView.text]
        
        recipe.updateDB()
        
        // TODO: Figure out why tab bar is gone
        self.performSegue(withIdentifier: "recipeListNavControllerSegue", sender: nil)
    }

    @IBAction func onAddIngredientButton(_ sender: AnyObject) {
        ingredientsArray.append(Ingredient())
        tableView.reloadData()
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
