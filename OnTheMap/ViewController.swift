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
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(self.emailInput.text)\", \"password\": \"\(self.passwordInput.text)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
    }
}

