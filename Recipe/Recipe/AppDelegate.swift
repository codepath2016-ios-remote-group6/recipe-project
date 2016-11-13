//
//  AppDelegate.swift
//  Recipe
//
//  Created by Iria on 11/7/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Parse initialization
        initializeParse()
        
        //Run a test on parse database
//        parseTest()
        print("Ran Parse Test")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeListViewController") as! RecipeListViewController
        
        window?.rootViewController = viewController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //*
    //**
    //My Functions
    //**
    //*
    func initializeParse(){
        //Register PFObject subclasses
        Recipe.registerSubclass()
        
        //Enable local datastore
        Parse.enableLocalDatastore()
        
        // Initialize Parse
        // Set applicationId and server based on the values in the Heroku settings.
        // clientKey is not used on Parse open source unless explicitly configured
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "measuringCupAppId"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey
                configuration.server = "https://measuring-cup.herokuapp.com/parse"
            })
        )
    }
    
    func parseTest(){
        
        let recipe: Recipe = Recipe()
        recipe.name = "Apple Pie"
        recipe.summary = "Delicious desert"
        recipe.prepTime = 1.5
        recipe.prepTimeUnits = "hours"
        
        var apples  = [String:AnyObject]()
        apples[Recipe.ingredientNameKey] = "apples" as AnyObject
        apples[Recipe.ingredientQuantityKey] = 2.0 as AnyObject
        apples[Recipe.ingredientUnitsKey] = "lbs" as AnyObject
        
        var crust = [String:AnyObject]()
        crust[Recipe.ingredientNameKey] = "pie crust" as AnyObject
        crust[Recipe.ingredientQuantityKey] = 1.0 as AnyObject
        crust[Recipe.ingredientUnitsKey] = "none" as AnyObject
        
        var ingredients: [Dictionary<String,AnyObject>] = Array<Dictionary<String,AnyObject>>()
        ingredients.append(apples)
        ingredients.append(crust)
        
        recipe.ingredients = ingredients
        
        print(recipe)
        
        recipe.saveInBackground(block: {(wasSuccessful: Bool, error: Error?)->Void in
            if let error = error{
                print("**********")
                print("save failed")
                print(error.localizedDescription)
            }else{
                print("**********")
                print("recipe saved successfully.")
                print("wasSuccessful: \(wasSuccessful) // error: \(error?.localizedDescription)")
            }
        })
        
    }


}

