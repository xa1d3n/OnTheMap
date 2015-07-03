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
    
    
    // MARK: - Methods
    struct Methods {
        // udacity session
        static let session : String = "session"
        // parse limit
        static let limit : String = "?limit=100"
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let Error = "error"
        static let Status = "status"
    }
}
