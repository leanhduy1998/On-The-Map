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
            //print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedData: [String:AnyObject]?  
            do {
                parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as? [String:AnyObject]
            }
            catch {
                print("parsing data err")
            }
            
            guard let account = parsedData?[UdacityConstant.Constant.account] as? [String:AnyObject] else {
                guard let statusCode = parsedData?[UdacityConstant.Constant.status] as? Int else {
                    print("status code err")
                    return
                }
                if(statusCode < 200 || statusCode > 299) {
                    guard let err = parsedData?[UdacityConstant.Constant.error] as? String else {
                        print("status code err err")
                        return
                    }
                    completionHandler(UdacityConstant.LoginError.couldNotLogin, err)
                    return
                }
                return
            }
            completionHandler("","")
        }
        task.resume()
        
    }
    

}
