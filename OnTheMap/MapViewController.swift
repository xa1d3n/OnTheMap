//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/1/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var studentInfo: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad() {
        
        // add pin button
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "pinLocation")
        
        // add refresh button
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
        // show the information postin view
        let informationPostingView : UINavigationController = storyboard?.instantiateViewControllerWithIdentifier("InformationPostingView") as! UINavigationController
        self.presentViewController(informationPostingView, animated: true, completion: nil)
        
    }
    
    // get list of user locations
    func getLocations() {
        UdacityCleint.sharedInstance().getStudentLocations { usersInfo, error in
            if let usersInfo =  usersInfo {
                self.studentInfo = usersInfo
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.createAnnotations(self.studentInfo)
                })
                
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert(error!)
                })
            }
        }
    }
    
    // show alert if error
    func showAlert(message: NSError) {
        self.presentViewController(UdacityCleint.sharedInstance().displayAlert(message), animated: true, completion: nil)
    }
    
    // populate map with user annotations
    func createAnnotations(users: [StudentInformation]) {
        for user in users {
            // set pin location
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
    
    // set pin properties
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinColor = .Red
            pinAnnotationView.canShowCallout = true
            
            // pin button
            let infoIcon = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIButton
            infoIcon.frame.size.width = 44
            infoIcon.frame.size.height = 44
            
            pinAnnotationView.rightCalloutAccessoryView = infoIcon
            
            return pinAnnotationView
        }
        return nil
    }
    
    // handle pin click
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        // open url in browser
        let urlString = view.annotation.subtitle
        let url = NSURL(string: urlString!)
        UIApplication.sharedApplication().openURL(url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // handle logout button
    @IBAction func logout(sender: UIBarButtonItem) {
        // facebook logout
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        
       UdacityCleint.sharedInstance().logoutUdacity { (result, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert(error!)
                })
            }
            else {
                 dispatch_async(dispatch_get_main_queue(), {
                    self.goToLoginView()
                })
            }
        }
        
        
    }
    
    // go back to login
    func goToLoginView() {
        let loginView : LoginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as! LoginViewController
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    
    // query parse if pin already exists
    func requiresOverwrite(uniqueKey: String) -> Bool {
        var needsOverwrite = false
        
        UdacityCleint.sharedInstance().queryStudentLocation(uniqueKey) { (result, error) -> Void in
            
            if error != nil {
                println("original")
            }
            else {
                if let results = result["results"] as? NSArray {
                    if results.count > 0 {
                        needsOverwrite = true
                    }
                }
            }
        }
        
        return needsOverwrite
    }

}
