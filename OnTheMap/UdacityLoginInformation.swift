//
//  UdacityLoginInformation.swift
//  OnTheMap
//
//  Created by Aldin Fajic on 7/4/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import Foundation

struct UdacityLoginInformation {
    var studentId = ""
    
    /* Construct a UdacityLoginInformation from a dictionary */
    init(dictionary: NSDictionary) {
        studentId = dictionary["key"] as! String
    }
}
