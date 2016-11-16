//
//  RecipeListViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginLogoutBarButton: UIBarButtonItem!
  
    var data = [Recipe]()
    var filteredData = [Recipe]()
    var query: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        filteredData = data
        
        setupLoginLogoutButton()
        
        getRecipesFromDb()
        
        //Bring in recipes from the api
        buildGenericRecipeList()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeListCell", for: indexPath) as! RecipeListCell
        let recipe = filteredData[indexPath.row]
        
        cell.recipe = recipe
        
        return cell
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter({(recipe: Recipe) -> Bool in
            return recipe.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.query = searchBar.text
        getRecipeListResults(pageNum: 0)
        self.searchBar.endEditing(true)
    }
    
    //*
    //*
    //Action outlets
    //*
    //*
    @IBAction func didTapLogoutBarButton(_ sender: UIBarButtonItem) {
        User.logout()
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier! {
            case "recipeViewSegue":
                let destinationViewController = segue.destination as! RecipeViewController
            
                let cell = sender as! UITableViewCell
                let indexPath = self.tableView.indexPath(for: cell)
                let recipe = data[(indexPath?.row)!]
                
                destinationViewController.recipe = recipe
            
            default:
                break
        }
    }
    
    @IBAction func unwindToRecipeList(segue: UIStoryboardSegue) {}
    
    
    //*
    //*
    //Low level functions
    //*
    //*
    
    func buildGenericRecipeList(){
        Recipe.searchFoodToFork(
            query: nil,
            page: nil,
            sort: nil,
            success: {(recipeDictList: [Dictionary<String,Any>])->Void in
                self.data = Recipe.recipes(recipeDictList: recipeDictList)
                self.filteredData = self.data
                self.tableView.reloadData()
            },
            failure: {(error: Error?)->Void in
                
                //failure code
                print("Error in RecipeList: \(error?.localizedDescription)")
                print(error)
        })
    }
    
    func getRecipeListResults(pageNum: Int){
        Recipe.searchFoodToFork(
            query: self.query,
            page: "\(pageNum)",
            sort: nil,
            success: {(recipeDictList: [Dictionary<String,Any>])->Void in
                self.data = Recipe.recipes(recipeDictList: recipeDictList)
                self.filteredData = self.data
                self.searchBar.text = ""
                self.tableView.reloadData()
            },
            failure: {(error: Error?)->Void in
                //failure code
        })
    }
    
    func setupLoginLogoutButton(){
        if PFUser.current() == nil {
            self.loginLogoutBarButton.title = "Log In"
        }
    }
    
    func getRecipesFromDb(){
        print("getting my recipes")
        Recipe.getRecipesFromDb(
            success: {(myRecipes: [Recipe]) -> Void in
                self.data = myRecipes
                self.filteredData = myRecipes
                self.tableView.reloadData()
                
                if myRecipes.isEmpty {
                    print("empty success")
                    let defaultList = Recipe.getDefaultRecipeList()
                    self.data = defaultList
                    self.filteredData = defaultList
                }
                
                print("My recipes: \(myRecipes)"
                )},
            failure: {(error: Error?) -> Void in
                print("Error retrieving my recipes: \(error?.localizedDescription)")})
    }

}
