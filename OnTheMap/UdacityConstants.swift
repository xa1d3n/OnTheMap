//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 6/30/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

extension UdacityCleint {
    
    // MARK: - Constants
    struct Constants {
        // parse app id
        static let parseAppId: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        // parse api key
        static let parseApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let BaseURLUdacity: String = "https://www.udacity.com/api/"
        static let BaseURLParse: String = "https://api.parse.com/1/classes/StudentLocation"
        
    }
    
    // MARK: - Parameters
    struct Parameters {
        
    }
    
    // MARK: - URL Types
    struct UrlTypes {
        static let parse : String = "parse"
        static let udacity : String = "udacity"
    }
    
    
    // MARK: - Methods
    struct Methods {
        // udacity session
        static let session : String = "session"
        // parse limit
        static let limit : String = "?limit=100"
        // public users data
        static let users : String = "users/"
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        // udacity
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        // parse
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let Error = "error"
        static let Status = "status"
        
        // MARK: StudentInformation
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MediaUrl = "mediaURL"
        
    }
}
