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
    
    var recipe: Recipe!
    var ingredientsArray: [Ingredient]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientsArray = Ingredient.IngredientsWithArray(dictionaries: recipe.ingredients as [NSDictionary])
        
        recipeNameLabel.text = recipe.name
        directionsTextView.text = recipe.summary
        
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        ingredientsTableView.alwaysBounceVertical = false
        ingredientsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        let recipeListViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecipeListViewController") as? RecipeListViewController
        
        navigationController?.pushViewController(recipeListViewController!, animated: true)
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

}
