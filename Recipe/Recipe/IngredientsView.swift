//
//  IngredientsView.swift
//  Recipe
//
//  Created by Craig Vargas on 12/6/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit

class IngredientsView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    public static let name = "IngredientsView"

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var ingredientCell = IngredientTVCell()
    var ingredientCellNib = UINib(nibName: IngredientTVCell.name, bundle: nil)
    
    var ingredientsAreInitialized = false
    
    var ingredients: Array<Ingredient>{
        didSet{
            if ingredientsAreInitialized{
                tableView.reloadData()
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        self.ingredients = Array<Ingredient>()
        super.init(frame: frame)
        initSubviews()
    }
    
    init(frame: CGRect, ingredients: [Ingredient]) {
        self.ingredients = ingredients
        ingredientsAreInitialized = true
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.ingredients = Array<Ingredient>()
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews(){
        let nib = UINib(nibName: IngredientsView.name, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        tableView.register(ingredientCellNib, forCellReuseIdentifier: IngredientTVCell.name)
        tableView.layer.cornerRadius = 5.0
        tableView.clipsToBounds = true
        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("IngredientsView: numberOfRowsInSection")
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("IngredientsView: cellForRowAt -> \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTVCell.name) as! IngredientTVCell
        cell.ingredient = ingredients[indexPath.row]
        return cell
    }
    

}
