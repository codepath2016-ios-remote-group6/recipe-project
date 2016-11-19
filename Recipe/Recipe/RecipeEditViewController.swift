//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi Kurhade on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class RecipeEditViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    var ingredientCount: Int = 0
    var items = [""]

    @IBOutlet weak var addIngredientTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIngredientTableView.rowHeight = UITableViewAutomaticDimension
        addIngredientTableView.estimatedRowHeight = 70
        addIngredientTableView.dataSource = self
        addIngredientTableView.delegate = self
        
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
        
        cell.nameLabel.text = items[indexPath.row]
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
       @IBAction func onAddIngredientClick(_ sender: Any) {
        
        items.append("Items \(items.count + 1)")
        
        addIngredientTableView.reloadData()
    }
    @IBAction func onDoneClick(_ sender: Any) {
        
        let recipe = Recipe()
        
        let ojbectId = recipe.objectId
        
        recipe.name = recipeNameTextField.text
        
        recipe.directions = (recipeDirectionsTextView.text as AnyObject) as! [String]
        
        //ingredient object 
        //recipe.ingredients =

        
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
