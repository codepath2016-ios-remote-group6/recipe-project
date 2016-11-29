//
//  User.swift
//  Recipe
//
//  Created by Craig Vargas on 11/14/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    public static let logoutNotification = Notification.Name("userLogout")
    public static let loggedInNotification = Notification.Name("userIsLoggedIn")
    
    public static let notFirstAppLaunchKey = "notFirstAppLaunch"
    
    class func logout(){
        PFUser.logOut()
        NotificationCenter.default.post(name: User.logoutNotification, object: nil)
    }
    
    class func login(){
//        NotificationCenter.default.post(name: User.logoutNotification, object: nil)
    }

}
