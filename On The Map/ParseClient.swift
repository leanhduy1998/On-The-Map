//
//  ParseClient.swift
//  On The Map
//
//  Created by Duy Le on 6/19/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation
import MapKit

class ParseClient {
    
    static func getStudentsLocationMap(completeHandler: @escaping (_ annotions: [MKPointAnnotation]?) -> Void){
        let HttpHeader = [ParseConstant.applicationID:"X-Parse-Application-Id",ParseConstant.RESTAPIKey:"X-Parse-REST-API-Key"]
        let HttpBody =  "".data(using: String.Encoding.utf8)
        HttpRequest(method: ParseConstant.method, HttpHeader: HttpHeader, HttpBody: HttpBody!, methodType: ParseConstant.MethodType.GET) { (data, error) in
            if error == nil {
                var annotationsArr = [MKPointAnnotation]()
                guard let results = data["results"] as? [[String:AnyObject]] else {
                    print("results err")
                    return
                }
                var emptyData = false
                for result in results {
                    guard let latitude = result["latitude"] as? Double else {
                        print("latitude err")
                        emptyData = true
                        continue
                    }
                    guard let longitude = result["longitude"] as? Double else {
                        print("longitude err")
                        emptyData = true
                        continue
                    }
                    guard let firstName = result["firstName"] as? String else {
                        print("firstName err")
                        emptyData = true
                        continue
                    }
                    guard let lastName = result["lastName"] as? String else {
                        print("lastName err")
                        emptyData = true
                        continue
                    }
                    guard let mediaURL = result["mediaURL"] as? String else {
                        print("mediaURL err")
                        emptyData = true
                        continue
                    }
                    emptyData = false
                    
                    if(emptyData==false){
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        annotation.title = "\(firstName) \(lastName)"
                        annotation.subtitle = mediaURL
                        annotationsArr.append(annotation)
                    }
                    
                }
                completeHandler(annotationsArr)
            }
        }

    }
    static func getStudentsLocationsAsList(completeHandler: @escaping(_ studentsArr: [[String:String]]) -> Void) {
        var studentsAsList = [[String:String]]()
        
        let HttpBody =  "".data(using: String.Encoding.utf8)
        HttpRequest(method: ParseConstant.method, HttpHeader: ParseConstant.HttpHeader, HttpBody: HttpBody!, methodType: ParseConstant.MethodType.GET) { (data, error) in
            if error == nil {
                guard let results = data["results"] as? [[String:AnyObject]] else {
                    print("results err")
                    return
                }
                for result in results {
                    guard let firstName = result["firstName"] as? String else {
                        print("firstName err")
                        continue
                    }
                    guard let lastName = result["lastName"] as? String else {
                        print("lastName err")
                        continue
                    }
                    guard let mediaURL = result["mediaURL"] as? String else {
                        print("mediaURL err")
                        continue
                    }
                    let name = "\(firstName) \(lastName)"
                    studentsAsList.append([name:mediaURL])
                }
                print("Done list")
                completeHandler(studentsAsList)
            }
        }
    }
    static func postStudentLocation(mapString:String, mediaURL: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, handleResult: @escaping () -> Void){
        
        let HttpBody = "{\"uniqueKey\": \"\(UdacityConstant.userInfo.accountKey!)\", \"firstName\": \"\(UdacityConstant.userInfo.firstName!)\", \"lastName\": \"\(UdacityConstant.userInfo.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude.description), \"longitude\": \(longitude.description)}".data(using: String.Encoding.utf8)
        
        var HttpHeader = ParseConstant.HttpHeader
        HttpHeader["application/json"] = "Content-Type"
        
        HttpRequest(method: ParseConstant.method, HttpHeader: HttpHeader, HttpBody: HttpBody!, methodType: ParseConstant.MethodType.POST) { (result, error) in
            if let err = result["error"] {
                print("err postStudentLocation")
                return
            }
            
            handleResult()
        }
    }
    static func putStudentLocation(objectId: String, mapString:String, mediaURL: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, handleResult: @escaping () -> Void){
        let HttpBody = "{\"uniqueKey\": \"\(UdacityConstant.userInfo.accountKey!)\", \"firstName\": \"\(UdacityConstant.userInfo.firstName!)\", \"lastName\": \"\(UdacityConstant.userInfo.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude.description), \"longitude\": \(longitude.description)}".data(using: String.Encoding.utf8)
        var HttpHeader = ParseConstant.HttpHeader
        HttpHeader["application/json"] = "Content-Type"
        
        let method = ParseConstant.method + "/\(objectId)"
        
        HttpRequest(method: ParseConstant.method, HttpHeader: HttpHeader, HttpBody: HttpBody!, methodType: ParseConstant.MethodType.POST) { (result, error) in
            if let err = result["error"] {
                print("err postStudentLocation")
                return
            }
            
            handleResult()
        }
    }
    
    static func getUserLocation(completeHandler: @escaping(_ result: [String]) -> Void){
        let HttpBody = "?where={\"uniqueKey\":\"\(UdacityConstant.userInfo.accountKey)\"}".data(using: String.Encoding.utf8)
        HttpRequest(method: ParseConstant.method, HttpHeader: ParseConstant.HttpHeader, HttpBody: HttpBody!, methodType: ParseConstant.MethodType.GET) { (results, error) in
            if error != nil {
                print("err getUserLocation")
                return
            }
            guard var resultsArr = results["results"] as? [[String: AnyObject]] else {
                print("resultArr err getUserLocation()")
                return
            }
            
            var objectIdArr = [String]()
            
            var count = 0
            for result in resultsArr{
                guard let firstName = result["firstName"] as? String else {
                    print("getUserLocation firstName err")
                    resultsArr.remove(at: count)
                    continue
                }
                guard let lastName = result["lastName"] as? String else {
                    print("getUserLocation lastName err")
                    resultsArr.remove(at: count)
                    continue
                }
                
                if firstName != UdacityConstant.userInfo.firstName {
                    resultsArr.remove(at: count)
                }
                else if lastName != UdacityConstant.userInfo.lastName {
                    resultsArr.remove(at: count)
                }
                else {
                    count = count+1
                    guard let objectId = result["objectId"] as? String else {
                        print("objectId err getUserLocation")
                        return
                    }
                    objectIdArr.append(objectId)
                }
            }
            completeHandler(objectIdArr)
        }
    }

    private static func HttpRequest(method: String, HttpHeader: [String:String], HttpBody: Data, methodType:String, handleResult: @escaping (_ result: AnyObject, _ error: String?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = methodType
        
        for(key,value) in HttpHeader {
            request.addValue(key, forHTTPHeaderField: value)
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
    
}
