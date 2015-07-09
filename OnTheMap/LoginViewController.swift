//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 6/29/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var login: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        // check facebook login status
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            println("not logged in")
        }
        else {
            self.goToMapView()
        }
        
        // add a facebook login button
        var loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height
        loginButton.frame = CGRectMake(10, (screenHeight - 50 - 10), screenWidth - 20, 50)
        
        loginButton.delegate = self
        
        // add the button to view
        self.view.addSubview(loginButton)
    }
    
    // MARK - Facebook Login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                println("loggin sucessful")
                self.goToMapView()
            }
        }else {
            showAlert(error)
        }
    }
    
    // MARK - Facebook Logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("logged out")
    }
    
    override func viewWillAppear(animated: Bool) {
       // login.enabled = false
        
        // set placeholder text
        emailInput.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        passwordInput.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }


    // udacity email/password login
    @IBAction func loginButton(sender: UIButton) {
        if emailInput.text.isEmpty {
            emailInput.becomeFirstResponder()
        }
        else if passwordInput.text.isEmpty {
            passwordInput.becomeFirstResponder()
        }
        else {
            loginUser();
        }
    }
    
    // login with udacity
    func loginUser() {
        
        startSpinner()
        
        UdacityCleint.sharedInstance().loginToUdacity(emailInput.text, password: passwordInput.text) { (result, error) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinner()
                    self.showAlert(error!)
                })
            }
            else {
                // show map tab view
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.studentId = result!.studentId
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopSpinner()
                    self.goToMapView()
                })
        
            }
        }
        
    }
    
    // go to map view
    func goToMapView() {
        var tabController:UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabs") as! UITabBarController
        self.presentViewController(tabController, animated: true, completion: nil)
    }
    
    // show error alert
    func showAlert(message: NSError) {
        self.presentViewController(UdacityCleint.sharedInstance().displayAlert(message), animated: true, completion: nil)
    }
    
    // start the spinner
    func startSpinner() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    // stop spinner
    func stopSpinner() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    // handle udacity account sign up button
    @IBAction func accountSignUp(sender: UIButton) {
        // get url
        let mediaURL = "https://www.udacity.com/account/auth#!/signup"
        let url = NSURL(string: mediaURL)!
        // open in browser
        UIApplication.sharedApplication().openURL(url)
    }
}

