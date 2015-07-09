//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/8/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit


struct StudentLocations {
    
    
    // get list of user locations
    static func getLocations(viewController: AnyObject)  {
        
        var studentInfo = [StudentInformation]()
        UdacityCleint.sharedInstance().getStudentLocations { usersInfo, error in
            if let info =  usersInfo {
                dispatch_async(dispatch_get_main_queue(), {
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.usersInfo = info
                    if let viewController = viewController as? MapViewController {
                        viewController.createAnnotations(info)
                    }
                })
                
            } else {
                if error != nil {
                    self.showAlert(error!, viewController: viewController)
                }
            }
        }
    }
    
    // logout of udacity or facebook
    static func logout(viewController: AnyObject) {
        // facebook logout
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        UdacityCleint.sharedInstance().logoutUdacity { (result, error) -> Void in
            if error != nil {
                self.showAlert(error!, viewController: viewController)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.goToLoginView(viewController)
                })
            }
        }
    }
    
    // go back to login view
    static func goToLoginView(viewController: AnyObject) {
        let loginView : LoginViewController = viewController.storyboard?!.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        viewController.presentViewController(loginView, animated: true, completion: nil)
    }
    
    // display alert
    static func showAlert(message: NSError, viewController: AnyObject) {
        viewController.presentViewController(UdacityCleint.sharedInstance().displayAlert(message), animated: true, completion: nil)
    }
    
    // open url
    static func openURL(urlString: String) {
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // pin location
    static func pinLocation(viewContrl: AnyObject) {
        let informationPostingView : UINavigationController = viewContrl.storyboard?!.instantiateViewControllerWithIdentifier("InformationPostingView") as! UINavigationController
        viewContrl.presentViewController(informationPostingView, animated: true, completion: nil)
    }
}