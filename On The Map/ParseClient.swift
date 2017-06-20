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
    private static var mapview: MKMapView!
    
    static func getStudentsLocation(){
        let HttpHeader = [ParseConstant.Constants.applicationID:"X-Parse-Application-Id",ParseConstant.Constants.RESTAPIKey:"X-Parse-REST-API-Key"]
        GETrequest(method: ParseConstant.Method.getLocation, HttpHeader: HttpHeader) { (data, error) in
            if error == nil {
                let results = data as? [[String:AnyObject]]
                for result in results! {
                    guard let latitude = result["latitude"] as? Double else {
                        print("latitude err")
                        return
                    }
                    guard let longitude = result["longitude"] as? Double else {
                        print("longitude err")
                        return
                    }
                    guard let firstName = result["firstName"] as? String else {
                        print("firstName err")
                        return
                    }
                    guard let lastName = result["lastName"] as? String else {
                        print("lastName err")
                        return
                    }
                    guard let mediaURL = result["mediaURL"] as? String else {
                        print("mediaURL err")
                        return
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    
                    mapview.addAnnotation(annotation)
                }
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
    static func setup(mapview: MKMapView){
        self.mapview = mapview
    }
    
}
