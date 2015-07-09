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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        // add pin button
        var pinButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: self, action: "pinLocation")
        
        // add refresh button
        var refreshButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "getStudentLocationsForMap")
        
        
        // add the buttons
        self.navigationItem.rightBarButtonItems = [refreshButton, pinButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // populate map with user locations
        getStudentLocationsForMap()
    }
    
    // get locations
    func getStudentLocationsForMap() {
        StudentLocations.getLocations(self)
    }
    
    // handle pin button click
    func pinLocation() {
        // show the information postin view
        StudentLocations.pinLocation(self)
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
        StudentLocations.openURL(view.annotation.subtitle!)
    }
    
    // handle logout button
    @IBAction func logout(sender: UIBarButtonItem) {
        StudentLocations.logout(self)
    }
    
}
