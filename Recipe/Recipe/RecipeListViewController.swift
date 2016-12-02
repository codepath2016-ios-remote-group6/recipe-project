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
    
    private static let numResultsPerRequest = 30
    private static let initialResultsIndex = 0
    private static let genericQuery = "recipe"

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginLogoutBarButton: UIBarButtonItem!
    @IBOutlet weak var addRecipeButton: UIButton!
    
    var controllerDataSource: String? = "database"
    
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
        
        // This needs to be here instead of viewWillAppear because having this code there causes a bug where text keeps getting added to the placeholder.
        if controllerDataSource != "database" {
            addRecipeButton.isHidden = true

            searchBar.placeholder = "\((searchBar.placeholder)!) or new search"
        }

        setupLoginLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if controllerDataSource == "database" {
            getRecipesFromDb()
        } else {
            //Bring in recipes from the api
            query = RecipeListViewController.genericQuery
            getRecipeListResults(pageNum: RecipeListViewController.initialResultsIndex)

        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = data[indexPath.row] as Recipe
            
            data.remove(at: indexPath.row) // also filteredData?
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            recipe.deleteFromDb()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return controllerDataSource == "database"
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
                destinationViewController.sourceType = self.controllerDataSource
            
            break
            case "newRecipeSegue":
                let destinationVc = segue.destination as! RecipeEditViewController
                destinationVc.setRecipe(recipe: nil)
            break
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
    
    func getRecipeListResults(pageNum: Int){
        if controllerDataSource == "database" {
            return
        }
        
        let startIndex = pageNum * RecipeListViewController.numResultsPerRequest
        Recipe.searchEdamam(
            forRecipesWithQuery: self.query,
            startIndex: startIndex,
            numResults: RecipeListViewController.numResultsPerRequest,
            success: {(recipeDictList: [Dictionary<String,Any>])->Void in
                self.data = Recipe.recipes(withEdamamRecipeDictList: recipeDictList)
                self.filteredData = self.data
                self.searchBar.text = ""
                if !self.filteredData.isEmpty{
                print("lets see the data: \(self.filteredData[0].imageUrlString)")
                }
                self.tableView.reloadData()},
            failure: {(error: Error?)->Void in
                //failure code
        })
    }
    
    func setupLoginLogoutButton(){
        if PFUser.current() == nil {
            self.loginLogoutBarButton.title = "Log In"
        }else{
            self.loginLogoutBarButton.title = "Log Out"
        }
    }
    
    func getRecipesFromDb(){
        print("getting my recipes")
        Recipe.getMyRecipes(
            success: {(myRecipes: [Recipe]) -> Void in
                self.data = myRecipes
                self.filteredData = myRecipes
                self.tableView.reloadData()
                
                // commenting this out for now because we already have pre-population on sign up. Keeping this around for testing purposes.
                if myRecipes.isEmpty {
                    let defaultList = Recipe.getDefaultRecipeList()
                    self.data = defaultList
                    self.filteredData = defaultList
                    self.tableView.reloadData()
                }
                
                print("My recipes: \(myRecipes)"
                )},
            failure: {(error: Error?) -> Void in
                print("Error retrieving my recipes: \(error?.localizedDescription)")})
    }

}
