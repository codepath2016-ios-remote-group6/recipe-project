//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi Kurhade on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class RecipeEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate ,UIPickerViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    var recipe: Recipe!
    var lastIngredientSaved = true
    
    var items = [""]
    var ingredientDetails = [["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25"],["1/8","1/4","1/3","1/2","2/3","3/4"]]
    
//    var ingredientDetails =
//        [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
//         ["1/8","1/4","1/3","1/2","2/3","3/4"]]
    
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
        
        populateView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return recipe.ingredients.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient: Dictionary<String,AnyObject> = self.recipe.ingredients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientListCell", for: indexPath) as! AddIngredientListCell
        cell.nameTextField.text = ingredient[Recipe.ingredientNameKey] as? String
        cell.unitTextField.text = ingredient[Recipe.ingredientUnitsKey] as? String
        cell.IngredientDetailsPickerView.selectRow(
            (self.recipe.ingredients[indexPath.row][Recipe.ingredientQuantityKey] as! Int) - 1,
            inComponent: 0, animated: true)
       
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
        
        let objectId = recipe.objectId
        
        recipe.name = recipeNameTextField.text
        
        recipe.directions = recipeDirectionsTextView.text        
        //ingredient object 
        //recipe.ingredients =

        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ingredientDetails.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingredientDetails[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ingredientDetails[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         print(component)
         print(row)
        
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setRecipe(recipe: Recipe?){
        if let recipe = recipe{
            self.recipe = recipe
            self.lastIngredientSaved = true
        }else{
            self.recipe = Recipe()
            self.lastIngredientSaved = false
        }
    }
    
    func populateView(){
        //Name
        self.recipeNameTextField.text = self.recipe.name
        //Ingredients
        self.addIngredientTableView.reloadData()
        //Directions
        if let directions = self.recipe.directions{
            self.recipeDirectionsTextView.text = directions
        }else{
            self.recipeDirectionsTextView.text = ""
        }
    }

}
