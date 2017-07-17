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
    
    
    
    var annotation = MKPointAnnotation()
    var latitude: Double!
    var longitude: Double!
    var firstName: String!
    var lastName: String!
    var mediaURL: String!
    
    init(studentInfo: [String:AnyObject]){
        let latitude = studentInfo["latitude"] as? Double ?? 0.0
        self.latitude = latitude
        
        let longitude = studentInfo["longitude"] as? Double ?? 0.0
        self.longitude = longitude
        
        
        let firstName = studentInfo["firstName"] as? String ?? ""
        self.firstName = firstName
        
        let lastName = studentInfo["lastName"] as? String ?? ""
        self.lastName = lastName
        
        let mediaURL = studentInfo["mediaURL"] as? String ?? ""
        self.mediaURL = mediaURL
        
        
   
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "\(firstName.description) \(lastName.description)"
        annotation.subtitle = mediaURL
        
    }
}
