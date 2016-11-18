//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Pallavi on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse


class RecipeEditViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var recipeNameTextField: UITextField!
    
    @IBOutlet weak var recipeDirectionsTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 3
        
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        
        let recipe = Recipe()
        
        let objectId = recipe.objectId
        
        recipe.name = recipeNameTextField.text
        
        recipe.directions = (recipeDirectionsTextView.text as AnyObject) as! [String]
        
        //ingredient object
        //recipe.ingredients =

        
    }
    @IBAction func onAddIngredientClick(_ sender: Any) {
        
        
        
        
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
