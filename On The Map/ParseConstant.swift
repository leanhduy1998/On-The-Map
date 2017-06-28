//
//  ParseConstant.swift
//  On The Map
//
//  Created by Duy Le on 6/19/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation

class ParseConstant {

    static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let HttpHeader = [ParseConstant.applicationID:"X-Parse-Application-Id",ParseConstant.RESTAPIKey:"X-Parse-REST-API-Key"]
    static let method = "https://parse.udacity.com/parse/classes/StudentLocation"
    
    struct MethodType {
        static let GET = "GET"
        static let POST = "POST"
    }
    struct userData {
        static var annotationObjectIdArr = [String]()
    }
}
