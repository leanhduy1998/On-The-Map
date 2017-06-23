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
        let HttpHeader = [ParseConstant.Constants.applicationID:"X-Parse-Application-Id",ParseConstant.Constants.RESTAPIKey:"X-Parse-REST-API-Key"]
        GETrequest(method: ParseConstant.Method.getLocation, HttpHeader: HttpHeader) { (data, error) in
            if error == nil {
                var annotationsArr = [MKPointAnnotation]()
                let results = data as? [[String:AnyObject]]
                var emptyData = false
                for result in results! {
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
                    
                    if(emptyData==false){
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        annotation.title = "\(firstName) \(lastName)"
                        annotation.subtitle = mediaURL
                        annotationsArr.append(annotation)
                    }
                    
                }
                print("done in Client")
                completeHandler(annotationsArr)
                
            }
        }

    }
    static func getStudentsLocationsAsList(completeHandler: @escaping(_ studentsArr: [[String:String]]) -> Void) {
        let HttpHeader = [ParseConstant.Constants.applicationID:"X-Parse-Application-Id",ParseConstant.Constants.RESTAPIKey:"X-Parse-REST-API-Key"]
        var studentsAsList = [[String:String]]()
        GETrequest(method: ParseConstant.Method.getLocation, HttpHeader: HttpHeader) { (data, error) in
            if error == nil {
                
                let results = data as? [[String:AnyObject]]
                for result in results! {
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

    private static func GETrequest(method: String, HttpHeader: [String:String], handleResult: @escaping (_ result: AnyObject?, _ error: String?) -> Void){
        let request = NSMutableURLRequest(url: URL(string: method)!)
        for(key,value) in HttpHeader {
            request.addValue(key, forHTTPHeaderField: value)
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                print("task err getStudentLocations")
                return
            }
            
            var parsedData: [String:AnyObject] = [:]
            do {
                try parsedData = (JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject])!
            }
            catch {
                print("parse data err")
            }
            guard let results = parsedData["results"] as? [[String:AnyObject]] else {
                print("results err")
                return
            }
            
            handleResult(results as AnyObject, nil)
        }
        task.resume()
    }
    
}
