//
//  RecipeListViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
  
    var data = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dummy data
        let recipe: Recipe = Recipe()
        recipe.name = "Apple Pie"
        recipe.summary = "Delicious desert"
        recipe.prepTime = 1.5
        recipe.prepTimeUnits = "hours"
        
        let recipe2: Recipe = Recipe()
        recipe2.name = "Cheesecake"
        recipe2.summary = "Delicious desert"
        recipe2.prepTime = 1.5
        recipe2.prepTimeUnits = "hours"
        
        data.append(recipe)
        data.append(recipe2)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListCell", for: indexPath) as! RecipeListCell
        
        let recipe = data[indexPath.row]
        
        cell.recipeNameLabel.text = recipe.name
        
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
