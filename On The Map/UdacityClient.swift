//
//  UdacityClient.swift
//  On The Map
//
//  Created by Duy Le on 6/18/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class UdacityClient {
    static func login(username: String, password: String, completionHandler: @escaping (_ alertTitle: String, _ alertMessage: String) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: UdacityConstant.Method.getSession)!)
        request.httpMethod = UdacityConstant.MethodType.POST
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let parsedData = convertData(data: newData!)
            
            guard let account = parsedData[UdacityConstant.account] as? [String:AnyObject] else {
                guard let statusCode = parsedData[UdacityConstant.status] as? Int else {
                    print("status code err")
                    return
                }
                if(statusCode < 200 || statusCode > 299) {
                    guard let err = parsedData[UdacityConstant.error] as? String else {
                        print("status code err err")
                        return
                    }
                    completionHandler(UdacityConstant.LoginError.couldNotLogin, err)
                    return
                }
                return
            }
            guard let key = account[UdacityConstant.key] as? String else {
                print("key err")
                return
            }
            UdacityConstant.userInfo.accountKey = Int(key)
            
            guard let session = parsedData[UdacityConstant.session] as? [String:AnyObject] else {
                print("session err")
                return
            }
            
            guard let id = session[UdacityConstant.id] as? String else {
                print("id err")
                return
            }
            UdacityConstant.userInfo.id = id
            completionHandler("","")
        }
        task.resume()
    }
    
    static func getUserPublicData(completeHandler: @escaping (_ data:[String:String])->Void){
        if (UdacityConstant.userInfo.id == nil) || UdacityConstant.userInfo.id.isEmpty {
            print("user not login yet, getUserPublicData")
            return
        }
        let request = NSMutableURLRequest(url: URL(string: UdacityConstant.Method.getPublicData)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print("task err")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let parsedData = convertData(data:  newData!)
            
            guard let user = parsedData[UdacityConstant.user] as? [String:AnyObject] else {
                print("user err")
                return
            }
            
            guard let lastName = user[UdacityConstant.lastName] as? String else {
                print("last name err")
                return
            }
            guard let firstName = user[UdacityConstant.firstName] as? String else {
                print("first name err")
                return
            }
            let name = "\(firstName) \(lastName)"
            completeHandler(["name":name])
            
        }
        task.resume()
    }
    private static func convertData(data: Data) -> [String:AnyObject]{
        var parsedData: [String:AnyObject]?
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        }
        catch {
            print("parsing data err")
        }
        return parsedData!
    }
    

}
