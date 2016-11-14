//
//  LoginViewController.swift
//  Recipe
//
//  Created by Iria on 11/11/16.
//  Copyright © 2016 Codepath Group 6. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var parentView: UIView!
    
    private static let animaitonDuration: TimeInterval = 0.4

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideErrorView()
        setupGestureRecognizers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //*
    //*
    //Actions
    //*
    //*
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        hideErrorView()
        signUpWithEmail()
    }
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
        hideErrorView()
        logInWithEmail()
    }
    
    @IBAction func didTapForgotPasswordButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapSkipButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //*
    //*
    //Low level detail functions
    //*
    //*
    private func signUpWithEmail(){
        let user = PFUser()
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let nickname = self.nicknameTextField.text
        
        //Check if user has entered all required fields
        if email != nil && email! != ""{
            if password != nil && password! != ""{
                if nickname != nil && nickname! != ""{
                    user.email = email
                    user.username = email
                    user.password = password
                    user["nickname"] = nickname
                    
                    //Sign user up
                    user.signUpInBackground(block: {(wasSuccessful: Bool, error: Error?)-> Void in
                        if let error = error as? NSError {
                            if let errorString = error.userInfo["error"] as? String{
                                // Show the errorString somewhere and let the user try again.
                                print("SignUp error: \(errorString)")
                                self.displayErrorView(message: errorString)
                            }
                        } else {
                            // Hooray! Let them use the app now.
                            print("SignUp Successful")
                        self.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
                        }})
                }else{
                    //prompt user to choose nickname
                    displayErrorView(message: "Please choose a nickname")
                }
            }else{
                //prompt user to enter password
                displayErrorView(message: "Please choose a password")
            }
        }else{
            //prompt user to enter email
            displayErrorView(message: "Please choose an email address")
        }
    }
    
    private func logInWithEmail(){
        
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        
        //Check if user has entered all required fields
        if email != nil && email! != ""{
            if password != nil && password! != ""{
                
                //Log user in
                PFUser.logInWithUsername(
                    inBackground: email!,
                    password: password!,
                    block: {(currentUser: PFUser?, error: Error?)-> Void in
                    if let error = error as? NSError {
                        let errorString = error.userInfo["error"] as? String
                        // Show the errorString somewhere and let the user try again.
                        print("LogIn error: \(errorString)")
                        self.displayErrorView(message: errorString)
                    } else {
                        // Hooray! Let them use the app now.
                        print("Login Successful. Current User: \(currentUser)")
                        self.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
                    }})
            }else{
                //prompt user to enter password
                displayErrorView(message: "Please enter your password")
            }
        }else{
            //prompt user to enter email
            displayErrorView(message: "Please enter your email address")
        }
    }
    
    func displayErrorView(message: String?){
        var displayMessage: String!
        if let unwrappedMessage = message{
            displayMessage = "Oops: " + unwrappedMessage
        }else{
            displayMessage = "Opps: Something went wrong..."
        }
        UIView.animate(withDuration: LoginViewController.animaitonDuration, animations: {
            self.errorLabel.text = displayMessage
            self.errorViewTopConstraint.constant = 0.0
            self.view.layoutIfNeeded()
//            self.errorView.isHidden = false
        })
    }
    
    func hideErrorView(){
        UIView.animate(withDuration: LoginViewController.animaitonDuration, animations: {
            self.errorLabel.text = ""
            self.errorViewTopConstraint.constant = -1.0 * self.errorViewHeightConstraint.constant
            self.view.layoutIfNeeded()
//            self.errorView.isHidden = true
        })
    }
    
    func setupGestureRecognizers(){
        let tapParent = UITapGestureRecognizer(target: self, action: #selector(didTapParentView))
        self.parentView.addGestureRecognizer(tapParent)
        
    }
    
    func didTapParentView(){
        parentView.endEditing(true)
    }
}
