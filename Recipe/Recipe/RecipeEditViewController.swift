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
    
    var flexCell = IngredientFlexTVCell()
    var flexCellNib = UINib(nibName: IngredientFlexTVCell.name, bundle: nil)
    
    var selectedIndexPath: IndexPath?
    
//    var ingredientDetails =
//        [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25],
//         ["1/8","1/4","1/3","1/2","2/3","3/4"]]
    
    @IBOutlet weak var addIngredientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIngredientTableView.rowHeight = UITableViewAutomaticDimension
        addIngredientTableView.estimatedRowHeight = 50
        addIngredientTableView.dataSource = self
        addIngredientTableView.delegate = self
        
        addIngredientTableView.register(flexCellNib, forCellReuseIdentifier: IngredientFlexTVCell.name)
        
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
        print("TV Function: cell for row at")
        let ingredient: Dictionary<String,AnyObject> = self.recipe.ingredients[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientFlexTVCell.name, for: indexPath) as! IngredientFlexTVCell
        cell.ingredient = ingredient
        if let selectedIndexPath = selectedIndexPath{
            if selectedIndexPath == indexPath{
                print("TV Function: cell for row at -> found selection")
                print("TV Function: cell for row at -> height = \(cell.cellHeight)")
                cell.showEditView()
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TV Function: did select row at")
        let cell = tableView.cellForRow(at: indexPath) as! IngredientFlexTVCell
        print("TV Function: did select row at -> height = \(cell.cellHeight)")
        print("TV Function: did select row at -> contentOffset = \(tableView.contentOffset)")
        print("TV Function: did select row at -> TV rowHeight = \(tableView.rowHeight)")

        
        if let unwrappedSelectedIndexPath = selectedIndexPath{
            print("change selection")
            if unwrappedSelectedIndexPath == indexPath{
                //unselecting the selected cell
                selectedIndexPath = nil
                cell.hideEditView()
                tableView.deselectRow(at: unwrappedSelectedIndexPath, animated: true)
                saveIngredient(index: indexPath.row, cell: cell)
            }else{
                //selecting a new cell
                let oldCell = tableView.cellForRow(at: unwrappedSelectedIndexPath) as! IngredientFlexTVCell
                oldCell.hideEditView()
                selectedIndexPath = indexPath
                cell.showEditView()
                saveIngredient(index: indexPath.row, cell: oldCell)
            }
        }else{
            print("new selection")
            //selecting a cell
            selectedIndexPath = indexPath
            cell.showEditView()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("TV Function: height for row at")

        if let selectedIndexPath = selectedIndexPath{
            if selectedIndexPath == indexPath{
                let cell = tableView.cellForRow(at: selectedIndexPath) as! IngredientFlexTVCell
                print("TV Function: height for row at -> found selection")
                print("TV Function: height for row at -> height = \(cell.cellHeight)")
                return cell.cellHeight
            }
        }
        return UITableViewAutomaticDimension
    }
    
    
    
    
    @IBAction func onAddIngredientClick(_ sender: Any) {
        recipe.ingredients.append(Dictionary<String,AnyObject>())
        addIngredientTableView.reloadData()
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        recipe.directions = recipeDirectionsTextView.text
        recipe.saveInBackground(
            block: {(successful: Bool, error: Error?)->Void in
                if successful{
                    print("Recipe save: succesful")
                }else{
                    print("Recipe save: Error saving")
                }})
    }
    
    @IBAction func didExitTextField(_ sender: UITextField) {
        recipe.name = recipeNameTextField.text
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
    
    func saveIngredient(index: Int, cell: IngredientFlexTVCell){
        recipe.ingredients[index][Recipe.ingredientNameKey] = cell.name as AnyObject
        recipe.ingredients[index][Recipe.ingredientQuantityKey] = cell.quantity as AnyObject
        recipe.ingredients[index][Recipe.ingredientUnitsKey] = cell.units as AnyObject
        recipe.ingredients[index][Recipe.ingredientAuxTextKey] = cell.displayText as AnyObject
    }


}
