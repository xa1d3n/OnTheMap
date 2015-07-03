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
    var usersInfo : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getLocations()
    }
    
    func getLocations() {
        UdacityCleint.sharedInstance().getStudentLocations { usersInfo, error in
            if let usersInfo: AnyObject = usersInfo {
                self.usersInfo = (usersInfo as? NSArray)!
                dispatch_async(dispatch_get_main_queue()) {
                    self.createAnnotations(self.usersInfo)
                }
            } else {
                println(error)
            }
        }
    }
    
    func createAnnotations(users: NSArray) {
        for user in users {
            var annotation = MKPointAnnotation()
            let latitude : CLLocationDegrees! = user["latitude"] as! CLLocationDegrees
            let longitude : CLLocationDegrees! = user["longitude"] as! CLLocationDegrees
            var location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            annotation.coordinate = location
            
            let firstName : String! = user["firstName"] as! String
            let lastName : String! = user["lastName"] as! String
            
            let fullName = UdacityCleint.sharedInstance().getFullName(firstName, lastName: lastName)
            annotation.title = fullName
            
            let mediaURL : String! = user["mediaURL"] as! String
            annotation.subtitle = mediaURL
            mapView.addAnnotation(annotation)
            
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadData(sender: UIBarButtonItem) {
        getLocations()
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