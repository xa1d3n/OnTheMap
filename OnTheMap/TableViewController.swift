//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/2/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class TableViewController: UITableViewController {
    var usersInfo : [StudentInformation] = [StudentInformation]()

    @IBOutlet var locationsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "pinLocation")
        
        var refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getLocations")
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getLocations()
    }
    
    // handle pin button click
    func pinLocation() {
        let informationPostingView : UINavigationController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingView") as! UINavigationController
        self.presentViewController(informationPostingView, animated: true, completion: nil)
        
    }
    
    // get list of users & their locations
    func getLocations() {
        UdacityCleint.sharedInstance().getStudentLocations { usersInfo, error in
            // load data
            if let usersInfo: [StudentInformation] = usersInfo {
                self.usersInfo = usersInfo
                dispatch_async(dispatch_get_main_queue()) {
                    self.locationsTable.reloadData()
                }
            } else {
                // show error
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert(error!)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("User", forIndexPath: indexPath) as! UITableViewCell
        
        // set cell data
        let firstName = usersInfo[indexPath.row].firstName
        let lastName = usersInfo[indexPath.row].lastName

        let fullName = UdacityCleint.sharedInstance().getFullName(firstName, lastName: lastName)
        cell.textLabel?.text = fullName
        let myImage = UIImage(named: "pin")
        cell.imageView?.image = myImage

        return cell
    }
    
    // open url in safari on table row click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get url
        let mediaURL = usersInfo[indexPath.row].mediaURL
        let url = NSURL(string: mediaURL)!
        // open in browser
        UIApplication.sharedApplication().openURL(url)
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return usersInfo.count
    }

    // logout of udacity
    @IBAction func logout(sender: UIBarButtonItem) {
        // facebook logout
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
        UdacityCleint.sharedInstance().logoutUdacity { (result, error) -> Void in
            if error != nil {
                self.showAlert(error!)
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.goToLoginView()
                })
            }
        }
    }
    
    // show login view on logout
    func goToLoginView() {
        let loginView : LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    // display alert
    func showAlert(message: NSError) {
        self.presentViewController(UdacityCleint.sharedInstance().displayAlert(message), animated: true, completion: nil)
    }

}
