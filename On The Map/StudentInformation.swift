//
//  StudentInformation.swift
//  On The Map
//
//  Created by Duy Le on 7/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import Foundation
import MapKit

class StudentInformation {
    var studentsAsList = [[String:String]]()
    var annotation = MKPointAnnotation()
    
    var latitude: Double!
    var longitude: Double!
    var firstName: String!
    var lastName: String!
    var mediaURL: String!
    
    init(studentInfo: [String:AnyObject]){
        if let latitude = studentInfo["latitude"] as? Double {
            self.latitude = latitude
        }
        
        if let longitude = studentInfo["longitude"] as? Double {
            self.longitude = longitude
        }
        
        if let firstName = studentInfo["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = studentInfo["lastName"] as? String {
            self.lastName = lastName
        }
        if let mediaURL = studentInfo["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        
        if latitude != nil && longitude != nil {
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
        }
    }
}
