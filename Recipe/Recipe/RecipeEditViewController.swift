//
//  RecipeEditViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class RecipeEditViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var directionsTextView: UITextView!
    
    var recipe: Recipe?
    
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
    
    @IBAction func onDoneButton(_ sender: AnyObject) {
        let recipeToUpdate = recipe ?? Recipe()
        
        recipeToUpdate.name = nameTextField.text
        
        // Temporary workaround while we figure out what to do with how directions are saved
        recipeToUpdate.directions = [directionsTextView.text]
        
        recipeToUpdate.update()
        
//        self.performSegue(withIdentifier: "unwindToRecipeList", sender: nil)
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
