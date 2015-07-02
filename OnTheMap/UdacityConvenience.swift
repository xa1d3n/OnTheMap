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
    
    func loginToUdacity(email: String, password: String, completionHandler: (result: AnyObject?, error: NSError?) -> Void) {
        
        // method
        var method : String = ""
        
        let parameters : [String:String] = [
            UdacityCleint.JSONBodyKeys.Username: email,
            UdacityCleint.JSONBodyKeys.Password: password
        ]
        
        let jsonBody : [String:AnyObject] = [
            UdacityCleint.JSONBodyKeys.Udacity: parameters
        ]
        
        // make the request
        let task = taskForPOSTMethod(method, jsonBody: jsonBody, subset: 5) { (result, error) -> Void in
            // send desired values to completion handler
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                if let errorMsg = result.valueForKey(UdacityCleint.JSONResponseKeys.Error)  as? String {
                    completionHandler(result: nil, error: NSError(domain: "udacity login issue", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMsg]))
                }
                else {
                    completionHandler(result: result, error: nil)
                }
            }
        }
    }

}