//
//  PublicUserInformation.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/4/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import Foundation

struct PublicUserInformation {
    var firstName = ""
    var lastName = ""
    
    /* Construct a PublicUserInformation from a dictionary */
    init(dictionary: NSDictionary) {
        firstName = dictionary["first_name"] as! String
        lastName = dictionary["last_name"] as! String
    }
}