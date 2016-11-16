//
//  FoodToForkTests.swift
//  Recipe
//
//  Created by Iria on 11/15/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import Foundation

func foodToForkTest(){
    print("**********")
    print("Calling Food2Fork Search Method")
    Recipe.searchFoodToFork(
        query: "chili",
        page: nil,
        sort: nil,
        success: {(recipeDictList: [Dictionary<String,Any>])->Void in
            print("**********")
            print("returned recipe list")
            print(recipeDictList)
            let recipes = Recipe.recipes(recipeDictList: recipeDictList)
            print("*********")
            print("Recipes Count: \(recipes.count)")
            print(recipes.last?.ingredientList)
        },
        failure: {(error: Error?)->Void in
            print(error?.localizedDescription)})
}
