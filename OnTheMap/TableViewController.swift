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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBOutlet var locationsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "pinLocation")
        
        let refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getStudentLocationsForTable")
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       // getLocations()
        getStudentLocationsForTable()
    }
    
    // get locations
    func getStudentLocationsForTable() {
        StudentLocations.getLocations(self)
        tableView.reloadData()
    }
    
    // handle pin button click
    func pinLocation() {
        // show the information postin view
        StudentLocations.pinLocation(self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("User", forIndexPath: indexPath) as UITableViewCell
        
        // set cell data
        let firstName = appDelegate.usersInfo[indexPath.row].firstName
        let lastName = appDelegate.usersInfo[indexPath.row].lastName

        let fullName = UdacityCleint.sharedInstance().getFullName(firstName, lastName: lastName)
        cell.textLabel?.text = fullName
        let myImage = UIImage(named: "pin")
        cell.imageView?.image = myImage

        return cell
    }
    
    // open url in safari on table row click
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // get url
        StudentLocations.openURL(appDelegate.usersInfo[indexPath.row].mediaURL)
        
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return appDelegate.usersInfo.count
    }

    // logout of udacity
    @IBAction func logout(sender: UIBarButtonItem) {
        // facebook logout
        StudentLocations.logout(self)
    }

}
