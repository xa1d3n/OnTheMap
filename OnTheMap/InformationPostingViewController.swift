//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/3/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit

class InformationPostingViewController: UIViewController, MKMapViewDelegate {

    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

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
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        // add cancel button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        
        // set placeholder text
        locationInput.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        linkInput.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // go back to map view
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // handle show map button
    @IBAction func showMap(sender: UIButton) {
        if (!locationInput.text.isEmpty) {
            getLocation(locationInput.text)
        }
        else {
            locationInput.becomeFirstResponder()
        }
    }
    
    // determine user location via geocoder
    func getLocation(address : String) {
        startSpinner()
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                self.stopSpinner()
                self.showAlert(error!)
            }
            else {
                self.mapView.hidden = false
                self.submitButton.hidden = false
                self.linkInput.hidden = false
                
                if let placemark = placemarks?[0] as? CLPlacemark {
                    self.latitude = placemark.location.coordinate.latitude
                    self.longitude = placemark.location.coordinate.longitude
                    self.placeMarkerOnMap(placemark)
                }
                self.stopSpinner()
            }

        })
    }
    
    // Set marker on map and zoom in
    func placeMarkerOnMap(placemark: CLPlacemark) {
        // set zoom
        var latDelta : CLLocationDegrees = 0.01
        var longDelta : CLLocationDegrees = 0.01
        
        // make span
        var span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        // create location
        var location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        // create region
        var region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(MKPlacemark(placemark: placemark))
    }
    

    // handle submit button
    @IBAction func submit(sender: UIButton) {
        
        // get public data udacity
        if (!linkInput.text.isEmpty) {
            
            if (UdacityCleint.sharedInstance().isValidURL(linkInput.text)) {
                // user data
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    getFacebookUserData()
                }
                else {
                    getUdacityUserData()
                }
            }
            else {
                let error = NSError(domain: "Invalid URL", code: 0, userInfo: ["NSLocalizedDescriptionKey" : "Invalid URL"])
                showAlert(error)
            }
        }
        else {
            linkInput.becomeFirstResponder()
        }
    }
    
    
    // show alert bar with message
    func showAlert(message: NSError) {
        self.presentViewController(UdacityCleint.sharedInstance().displayAlert(message), animated: true, completion: nil)
    }
    
    // start the activity indicator
    func startSpinner() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    // stop the activity indicator
    func stopSpinner() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    // post location to parse
    func postLocation(userInfo: [String: AnyObject]) {
        
        UdacityCleint.sharedInstance().postUserLocation(userInfo, completionHandler: { (result, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert(error!)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cancel()
                })
            }
        })
    }
    
    // get user data from udacity
    func getUdacityUserData() {
        var userInfo : [String: AnyObject] = [String: AnyObject]()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        apiKey = appDelegate.studentId
        UdacityCleint.sharedInstance().getUserPublicData(apiKey, completionHandler: { (result, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert(error!)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    userInfo  = [
                        UdacityCleint.JSONBodyKeys.UniqueKey: self.apiKey,
                        UdacityCleint.JSONBodyKeys.FirstName: result!.firstName,
                        UdacityCleint.JSONBodyKeys.LastName: result!.lastName,
                        UdacityCleint.JSONBodyKeys.MapString: self.locationInput.text,
                        UdacityCleint.JSONBodyKeys.MediaURL: self.linkInput.text,
                        UdacityCleint.JSONBodyKeys.Latitude: self.latitude,
                        UdacityCleint.JSONBodyKeys.Longitude: self.longitude
                    ]
                    self.postLocation(userInfo)
                })
            }
        })
    }
    
    // get user data from facebook
    func getFacebookUserData()
    {
        var userInfo : [String: AnyObject] = [String: AnyObject]()
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            
            if ((error) != nil)
            {
                // Process error
                self.showAlert(error)
            }
            else
            {
                
                dispatch_async(dispatch_get_main_queue(), {
                    userInfo = [
                        UdacityCleint.JSONBodyKeys.UniqueKey: result.valueForKey("id") as! String,
                        UdacityCleint.JSONBodyKeys.FirstName: result.valueForKey("first_name") as! String,
                        UdacityCleint.JSONBodyKeys.LastName: result.valueForKey("last_name") as! String,
                        UdacityCleint.JSONBodyKeys.MapString: self.locationInput.text,
                        UdacityCleint.JSONBodyKeys.MediaURL: self.linkInput.text,
                        UdacityCleint.JSONBodyKeys.Latitude: self.latitude,
                        UdacityCleint.JSONBodyKeys.Longitude: self.longitude
                    ]
                    self.postLocation(userInfo)
                })
            }
        })
    }
}
