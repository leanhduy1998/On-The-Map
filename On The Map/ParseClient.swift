//
//  ParseClient.swift
//  On The Map
//
//  Created by Duy Le on 6/19/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation
import MapKit
import SystemConfiguration

class ParseClient {
    
    static func getStudentsLocationMap(completeHandler: @escaping (_ studentInfo: [StudentInformation]?, _ error: String) -> Void){
        let HttpHeader = [ParseConstant.applicationID:"X-Parse-Application-Id",ParseConstant.RESTAPIKey:"X-Parse-REST-API-Key"]
        let HttpBody =  "".data(using: String.Encoding.utf8)
        
        let limiter = "?limit=100"
        let order = "&order=-updatedAt"
        var url = "\(ParseConstant.Method.studentLocation)"
        url.append(limiter)
        url.append(order)
        
        HttpRequest(method: url, HttpHeader: HttpHeader, addOrSetHttpHeader: "add", HttpBody: HttpBody!, methodType: ParseConstant.MethodType.GET) { (data, error) in
            if error == nil {
                guard let results = data["results"] as? [[String:AnyObject]] else {
                    completeHandler(nil, "Cannot get locations, results err")
                    return
                }
                
                var studentInfoArr = [StudentInformation]()
                for result in results {
                    let studentInfo = StudentInformation(studentInfo: result)
                    studentInfoArr.append(studentInfo)
                }
                completeHandler(studentInfoArr, "")
            }
        }

    }
    static func getStudentsLocationsAsList(completeHandler: @escaping(_ studentsArr: [StudentInformation]) -> Void) {
        var studentsAsList = [StudentInformation]()
        
        let HttpBody =  "".data(using: String.Encoding.utf8)
        
        let limiter = "?limit=100"
        let order = "&order=-updatedAt"
        var url = "\(ParseConstant.Method.studentLocation)"
        url.append(limiter)
        url.append(order)
        
        HttpRequest(method: url, HttpHeader: ParseConstant.HttpHeader, addOrSetHttpHeader: "add", HttpBody: HttpBody!, methodType: ParseConstant.MethodType.GET) { (data, error) in
            if error == nil {
                guard let results = data["results"] as? [[String:AnyObject]] else {
                    print("results err")
                    return
                }
                for result in results {
                    let studentInfo = StudentInformation(studentInfo: result)

                    studentsAsList.append(studentInfo)
                }
                completeHandler(studentsAsList)
            }
        }
    }
    static func postStudentLocation(mapString:String, mediaURL: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, handleResult: @escaping () -> Void){
        
        let HttpBody = "{\"uniqueKey\": \"\(UdacityConstant.userInfo.accountKey!)\", \"firstName\": \"\(UdacityConstant.userInfo.firstName.description)\", \"lastName\": \"\(UdacityConstant.userInfo.lastName.description)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude.description), \"longitude\": \(longitude.description)}".data(using: String.Encoding.utf8)
        
        var HttpHeader = ParseConstant.HttpHeader
        HttpHeader["application/json"] = "Content-Type"
        
        HttpRequest(method: ParseConstant.Method.studentLocation, HttpHeader: HttpHeader, addOrSetHttpHeader: "add", HttpBody: HttpBody!, methodType: ParseConstant.MethodType.POST) { (result, error) in
            if let err = result["error"] {
                print("err postStudentLocation \(String(describing: err))")
                return
            }
            
            handleResult()
        }
    }
    static func putStudentLocation(objectId: String, mapString:String, mediaURL: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, handleResult: @escaping (_ error: String) -> Void){
        let HttpBody = "{\"uniqueKey\": \"\(UdacityConstant.userInfo.accountKey!)\", \"firstName\": \"\(UdacityConstant.userInfo.firstName.description)\", \"lastName\": \"\(UdacityConstant.userInfo.lastName.description)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude.description), \"longitude\": \(longitude.description)}".data(using: String.Encoding.utf8)
        
        var HttpHeader = ParseConstant.HttpHeader
        HttpHeader["application/json"] = "Content-Type"
        
        let method = ParseConstant.Method.studentLocation + "/\(objectId)"
        
        HttpRequest(method: method, HttpHeader: HttpHeader, addOrSetHttpHeader: "add", HttpBody: HttpBody!, methodType: ParseConstant.MethodType.PUT) { (result, error) in
            let err = error
            if err != nil {
                print("err putStudentLocation \(String(describing: err))")
                handleResult((err?.description)!)
                return
            }
            handleResult("")
        }
    }
    
    static func getUserLocationObjectId(completeHandler: @escaping(_ result: [String]) -> Void){
        let optionalParameters = "?where={\"uniqueKey\":\"\( UdacityConstant.userInfo.accountKey.description)\"}"
        let url = "\(ParseConstant.Method.studentLocation)\(optionalParameters)"
        
        let emptyData = Data()
        
        HttpRequest(method: url, HttpHeader: ParseConstant.HttpHeader, addOrSetHttpHeader: "add", HttpBody: emptyData, methodType: ParseConstant.MethodType.GET) { (results, error) in
            if error != nil {
                print("err getUserLocation")
                return
            }
            guard let resultsArr = results["results"] as? [[String: AnyObject]] else {
                print("resultArr err getUserLocation()")
                return
            }
            var objectIdArr = [String]()
            
            for result in resultsArr{
                guard let objectId = result["objectId"] as? String else {
                    print("getUserLocation objectId err")
                    return
                }
                objectIdArr.append(objectId)
            }
            completeHandler(objectIdArr)
        }
    }
    static func deleteSession(completeHandler: @escaping () -> Void){
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var HttpHeader = [String:String]()
        if let xsrfCookie = xsrfCookie {
            HttpHeader[xsrfCookie.value] = "X-XSRF-TOKEN"
        }
        
        let HttpBody = "".data(using: .utf8)
        
        HttpRequest(method: ParseConstant.Method.session, HttpHeader: HttpHeader, addOrSetHttpHeader: "set", HttpBody: HttpBody!, methodType: ParseConstant.MethodType.DELETE) { (data, error) in
            if error != nil {
                print("err deleteSession")
                return
            }
            print(data)
            completeHandler()
        }
    }

    private static func HttpRequest(method: String, HttpHeader: [String:String], addOrSetHttpHeader: String, HttpBody: Data, methodType:String, handleResult: @escaping (_ result: AnyObject, _ error: String?) -> Void){

        let url = method.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let request = NSMutableURLRequest(url: URL(string: url!)!)
        request.httpMethod = methodType
        
        if addOrSetHttpHeader == "add" {
            for(key,value) in HttpHeader {
                request.addValue(key, forHTTPHeaderField: value)
            }
        }
        else {
            for(key,value) in HttpHeader {
                request.setValue(key, forHTTPHeaderField: value)
            }
        }

        request.httpBody = HttpBody
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                print("task err get")
                return
            }
            
            var parsedData: [String:AnyObject] = [:]
            do {
                try parsedData = (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject])!
            }
            catch {
                print("parse data err")
            }
            
            handleResult(parsedData as AnyObject, nil)
        }
        task.resume()
    }
    static func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}
