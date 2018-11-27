//
//  FireURL.swift
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

import Foundation

func fireURL(url:String) -> String {
    var response = "ERROR: Unknown HTTP Response"
    
    response = HTTPRequester.performGetRequest(URL(string: url))
    
    if response.range(of:"REDIRECT:") != nil {
        // Get redirect link
        let redirectRange = response.index(response.startIndex, offsetBy: 9)...
        let redirectLink = String(response[redirectRange])
        
        // Make recursive call
        response = fireURL(url: redirectLink)
    } else if response.range(of:"ERROR: Done") != nil {
        return "ERROR: Unknown HTTP Response"
    }
    
    return response
}
