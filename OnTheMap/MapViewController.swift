//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/1/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var studentInfo: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad() {
        
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "pinLocation")
        
        var refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getLocations")
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        getLocations()
    }
    
    func pinLocation() {
        let informationPostingView : UINavigationController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingView") as! UINavigationController
        self.presentViewController(informationPostingView, animated: true, completion: nil)
        
    }
    
    func getLocations() {
        UdacityCleint.sharedInstance().getStudentLocations { usersInfo, error in
            if let usersInfo =  usersInfo {
                self.studentInfo = usersInfo
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.createAnnotations(self.studentInfo)
                })
                
            } else {
                println(error)
            }
        }
    }
    
    func createAnnotations(users: [StudentInformation]) {
        for user in users {
            var annotation = MKPointAnnotation()
            let latitude = user.latitude
            let longitude = user.longitude
            var location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.coordinate = location
            
            let firstName = user.firstName
            let lastName = user.lastName
            
            let fullName = UdacityCleint.sharedInstance().getFullName(firstName, lastName: lastName)
            annotation.title = fullName
            
            let mediaURL = user.mediaURL
            annotation.subtitle = mediaURL
            mapView.addAnnotation(annotation)
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout(sender: UIBarButtonItem) {
        UdacityCleint.sharedInstance().logoutUdacity { (result, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                 dispatch_async(dispatch_get_main_queue(), {
                    let loginView : ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! ViewController
                    self.presentViewController(loginView, animated: true, completion: nil)
                })
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
