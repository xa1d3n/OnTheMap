//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/3/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {



    @IBOutlet weak var linkInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var apiKey = ""
    var firstName = ""
    var lastName = ""
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showMap(sender: UIButton) {
        if (!locationInput.text.isEmpty) {
            mapView.hidden = false
            submitButton.hidden = false
            linkInput.hidden = false
            getLocation(locationInput.text)
        }
        else {
            locationInput.becomeFirstResponder()
        }
    }
    
    func getLocation(address : String) {

        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                self.latitude = placemark.location.coordinate.latitude
                self.longitude = placemark.location.coordinate.longitude
                println("found you")
            }
            else {
                println("cannot find you")
            }
        })
    }

    @IBAction func submit(sender: UIButton) {
        // get public data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        apiKey = appDelegate.studentId
        UdacityCleint.sharedInstance().getUserPublicData(apiKey, completionHandler: { (result, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                self.firstName = result!.firstName
                self.lastName = result!.lastName
                self.postLocation()
            }
        })
    }
    
    func postLocation() {
        
        let userInfo : [String : AnyObject] = [
            UdacityCleint.JSONBodyKeys.UniqueKey: apiKey,
            UdacityCleint.JSONBodyKeys.FirstName: firstName,
            UdacityCleint.JSONBodyKeys.LastName: lastName,
            UdacityCleint.JSONBodyKeys.MapString: locationInput.text,
            UdacityCleint.JSONBodyKeys.MediaURL: linkInput.text,
            UdacityCleint.JSONBodyKeys.Latitude: latitude,
            UdacityCleint.JSONBodyKeys.Longitude: longitude
        ]
        
        UdacityCleint.sharedInstance().postUserLocation(userInfo, completionHandler: { (result, error) -> Void in
            if error != nil {
                println(error)
            }
            else {
                println(result)
            }
        })
    }
}
