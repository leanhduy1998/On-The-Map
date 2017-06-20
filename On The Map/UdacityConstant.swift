//
//  UdacityConstant.swift
//  On The Map
//
//  Created by Duy Le on 6/18/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation

class UdacityConstant {
    struct Constant {
        static let status = "status"
        static let error = "error"
        static let key = "key"
        static let account = "account"
    }
    struct MethodType {
        static let POST = "POST"
    }
    struct Method {
        static let getSession  = "https://www.udacity.com/api/session"
    }
    struct LoginError {
        static let usernameTitle = "Username/email Missing!"
        static let usernameMessage = "Please fill your username/email!"
        static let passwordTitle = "Password Missing!"
        static let passwordMessage = "Please fill your password!"
        static let couldNotLogin = "Could not login your account!"
    }
    struct userInfo {
        static var id: String!
        static var accountKey: Int!
        static var registered: Bool!
    }
    
}
