//
//  ViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 6/29/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
       // login.enabled = false
    }


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
    
    func loginUser() {
        
        UdacityCleint.sharedInstance().loginToUdacity(emailInput.text, password: passwordInput.text) { (result, error) -> Void in
            if error != nil {
                // TODO - alert
                if let userInfo = error!.userInfo as? [NSObject: NSObject] {
                    println(userInfo["NSLocalizedDescription"])
                }
            }
            else {
                // show map tab view
                dispatch_async(dispatch_get_main_queue(), {
                    let tabController:UITabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabs") as! UITabBarController
                    self.presentViewController(tabController, animated: true, completion: nil)
                })
        
            }
        }
        
    }
}

