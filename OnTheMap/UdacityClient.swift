//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 6/30/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import Foundation

class UdacityCleint {
    // shared session
    var session: NSURLSession
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    // MARK: - POST
    
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], subset: Int, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        // build the url and configure the request
        let urlString = Constants.BaseURLUdacity + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        // make the request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response,
            error) -> Void in
            

            if error != nil { // Handle error…
                completionHandler(result: nil, error: error)
            }
            else {
                var newData: NSData?
                newData = nil
                if subset > 0 {
                    newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                }
                //completionHandler(result: NSString(data: data, encoding: NSUTF8StringEncoding), error: nil)
                if newData != nil {
                    UdacityCleint.parseJSONWithCompletionHandler(newData!, completionHandler: completionHandler)
                }
                else {
                    UdacityCleint.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                }
            }
        })
        
        task.resume()
        
        return task
    }
    
    
    // MARK: - GET
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) ->Void ) -> NSURLSessionDataTask {
        // build the url
        let urlString = Constants.BaseURLParse + method
        let url = NSURL(string: urlString)!
        // build the request
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.parseAppId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.parseApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                completionHandler(result: nil, error: error)
            }
            else {
                UdacityCleint.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        })
        
        task.resume()
        
        return task
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityCleint {
        
        struct Singleton {
            static var sharedInstance = UdacityCleint()
        }
        
        return Singleton.sharedInstance
    }
    
}