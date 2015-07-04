//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/4/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import MapKit

struct StudentInformation {
    var firstName = ""
    var lastName = ""
    var latitude : CLLocationDegrees = CLLocationDegrees()
    var longitude : CLLocationDegrees =  CLLocationDegrees()
    var mediaURL = ""
    var studentId = ""
    
    /* Construct a StudentInformation from a dictionary */
    init(dictionary: [String : AnyObject]) {
        firstName = dictionary[UdacityCleint.JSONResponseKeys.FirstName] as! String
        lastName = dictionary[UdacityCleint.JSONResponseKeys.LastName] as! String
        latitude = dictionary[UdacityCleint.JSONResponseKeys.Latitude] as! CLLocationDegrees
        longitude = dictionary[UdacityCleint.JSONResponseKeys.Longitude] as! CLLocationDegrees
        mediaURL = dictionary[UdacityCleint.JSONResponseKeys.MediaUrl] as! String
        
    }
    
    
    /* Helper: Given an array of dictionaries, convert them to an array of StudentInformation objects */
    static func infoFromResults(results: [[String : AnyObject]]) -> [StudentInformation] {
        var studentInfo = [StudentInformation]()
        
        for result in results {
            studentInfo.append(StudentInformation(dictionary: result))
        }
        
        return studentInfo
    }
}
