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
    
    struct Method {
        static let studentLocation = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let session = "https://www.udacity.com/api/session"

    }
    struct MethodType {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    struct userData {
        static var annotationObjectIdArr = [String]()
    }
}
