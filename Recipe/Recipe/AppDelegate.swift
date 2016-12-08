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
        
        initializeParse()
        loadInitialViewController()
        setupNotificationObserver()

//        parseTest()
        
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
    
    func loadInitialViewController(){
        
        let notFirstAppLaunch = UserDefaults.standard.bool(forKey: User.notFirstAppLaunchKey)
        
        if notFirstAppLaunch {
            showFirstViewController()
        }else{
            UserDefaults.standard.set(true, forKey: User.notFirstAppLaunchKey)
            UserDefaults.standard.synchronize()
            showIntroViewController()
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let recipeListNavConroller = storyboard.instantiateViewController(withIdentifier: "RecipeListNavController") as! UINavigationController
////        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipeListViewController") as! RecipeListViewController
//        
//        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        
//        if PFUser.current() == nil{
//            window?.rootViewController = loginViewController
//        }else{
//            window?.rootViewController = recipeListNavConroller
//        }
    }
    
    func setupNotificationObserver(){
        NotificationCenter.default.addObserver(
            forName: User.logoutNotification,
            object: nil,
            queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                self.showLoginViewController()})
        
        NotificationCenter.default.addObserver(
            forName: IntroViewController.finishedIntroNotification,
            object: nil,
            queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                self.showFirstViewController()})
        
        NotificationCenter.default.addObserver(
            forName: User.loggedInNotification,
            object: nil,
            queue: OperationQueue.main,
            using: {(notification: Notification)->Void in
                self.showRecipeListViewController()})
    }
    
    func showFirstViewController(){
        if PFUser.current() == nil{
            showLoginViewController()
        }else{
            showRecipeListViewController()
        }
    }
    
    func showLoginViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        window?.rootViewController = loginVc
    }
    
    func showRecipeListViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Set up Saved Recipe List
        let dbRecipeListNC = storyboard.instantiateViewController(withIdentifier: "RecipeListNavController") as! UINavigationController
        let dbRecipeListVC = dbRecipeListNC.topViewController as! RecipeListViewController
        
        dbRecipeListVC.controllerDataSource = "database"
        dbRecipeListNC.tabBarItem.title = "My Recipes"
        dbRecipeListNC.tabBarItem.image = UIImage(named: "saved-recipes-icon")
        
        // Set up Browse Recipe List
        let apiRecipeListNC = storyboard.instantiateViewController(withIdentifier: "RecipeListNavController") as! UINavigationController
        let apiRecipeListVC = apiRecipeListNC.topViewController as! RecipeListViewController
        
        apiRecipeListVC.controllerDataSource = "edamam"
        apiRecipeListNC.tabBarItem.title = "Browse"
        apiRecipeListNC.tabBarItem.image = UIImage(named: "browse-recipes-icon")
        
        // Programatically create tab view
        let tabBarController = UITabBarController()
//        tabBarController.tabBar.barTintColor = Colors.appPrimary
        tabBarController.tabBar.tintColor = UIColor(hue: 79.0, saturation: 0.0, brightness: 0.0, alpha: 0.8)
        
        tabBarController.viewControllers = [dbRecipeListNC, apiRecipeListNC]
        
        window?.rootViewController = tabBarController
    }
    
    func showIntroViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let introVc = storyboard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
        window?.rootViewController = introVc
    }
    
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
}

