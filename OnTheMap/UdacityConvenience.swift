//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 6/30/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import Foundation


// MARK: - Convenient Resource Methods

extension UdacityCleint {
    
    // MARK: - POST Convenience Methods
    
    func loginToUdacity(email: String, password: String, completionHandler: (result: UdacityLoginInformation?, error: NSError?) -> Void) {
        
        // method
        let method = Methods.session
        
        let parameters : [String:String] = [
            UdacityCleint.JSONBodyKeys.Username: email,
            UdacityCleint.JSONBodyKeys.Password: password
        ]
        
        let jsonBody : [String:AnyObject] = [
            UdacityCleint.JSONBodyKeys.Udacity: parameters
        ]
        
        // make the request
        let task = taskForPOSTMethod(method, urlType: UrlTypes.udacity,jsonBody: jsonBody, subset: 5) { (result, error) -> Void in
            // send desired values to completion handler
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let errorMsg = result.valueForKey(UdacityCleint.JSONResponseKeys.Error)  as? String {
                    completionHandler(result: nil, error: NSError(domain: "udacity login issue", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMsg]))
                }
                else {
                    let session = result["account"] as! NSDictionary
                    let udacityInfo = UdacityLoginInformation(dictionary: session)
                    completionHandler(result: udacityInfo, error: nil)
                }
            }
        }
    }
    
    // post user location to parse
    func postUserLocation(userDetails: [String : AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        let parameters = userDetails
        
        // make the request
        let task = taskForPOSTMethod("", urlType: UrlTypes.parse, jsonBody: parameters, subset: 0) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                print(result)
                completionHandler(result: result, error: nil)

            }
        }
    }
    
    // MARK - GET Convenience Methods
    // get student locations from parse
    func getStudentLocations(completionHandler: (result: [StudentInformation]?, error: NSError?) -> Void) {
        // method
        let method = Methods.limit
        
        // make the request
        let task = taskForGETMethod(method, type: UrlTypes.parse, subset: 0) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let locations = result as? [NSObject: NSObject] {
                    if let usersInfo = locations["results"] as? [[String : AnyObject]] {
                        let studentsInfo = StudentInformation.infoFromResults(usersInfo)
                        completionHandler(result: studentsInfo, error: nil)
                    }
                }
            }
        }
    }
    
    // query user location from parse
    func queryStudentLocation(uniqueKey: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        let method = Methods.WhereQuery + uniqueKey + "%22%7D"
        
        let task = taskForGETMethod(method, type: UrlTypes.parse, subset: 0) { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                completionHandler(result: result, error: nil)
            }
        
        }
    }
    
    // get user public data from udacity
    func getUserPublicData(userId: String, completionHandler: (result: PublicUserInformation?, error: NSError?) -> Void) {
        // method
        let method = Methods.users + userId
        
        // mak the request
        let task = taskForGETMethod(method, type: UrlTypes.udacity, subset: 5, completionHandler: { (result, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let data = result["user"] as? NSDictionary {
                    let studentsInfo = PublicUserInformation(dictionary: data)
                    completionHandler(result: studentsInfo, error: nil)
                }
            }
        })
        
    }
    
    // logout of udacity
    func logoutUdacity(completionHandler: (result: AnyObject?, error: NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURLUdacity + Methods.session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-Token")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(result: nil, error: error)
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
           // println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            completionHandler(result: newData, error: nil)
        }
        task!.resume()
    }
    
    // display alert helper
    func displayAlert(error: NSError) -> UIAlertController {
        let errMessage = error.localizedDescription
        
        /* if let userInfo = error.userInfo as? [NSObject: NSObject] {
            errMessage = userInfo["NSLocalizedDescription"] as! String
        } */

        
        let alert = UIAlertController(title: nil, message: errMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        return alert
    }
    
    // get full name helper function
    func getFullName(firstName: String, lastName: String) -> String {
        let fullName = "\(firstName) \(lastName)"
        
        return fullName
    }
    
    // validate url
    func isValidURL(urlString: String) -> Bool {
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        return NSURLConnection.canHandleRequest(request)
    }

}