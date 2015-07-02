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
        static let BaseURL: String = "https://www.udacity.com/api/session"
    }
    
    // MARK: - Methods
    struct Methods {
        // login
        static let LoginSession = "{\"udacity\": {\"{email}\": \"account@domain.com\", \"password\": \"{password}\"}}"
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
