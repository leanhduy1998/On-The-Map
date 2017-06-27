//
//  AddLinkToAnnotationViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/23/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import MapKit

class AddLinkToAnnotationViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    
    var annotation = MKPointAnnotation()
    var mapString = String()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapview.addAnnotation(annotation)
        mapview.centerCoordinate = annotation.coordinate
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        ParseClient.postStudentLocation(mapString: mapString, mediaURL: linkTF.text!, latitude: annotation
            .coordinate.latitude, longitude: annotation.coordinate.longitude) { (data, error) in
                print("submitBtnClicked")
                print(data)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapview.centerCoordinate =
            (userLocation.location?.coordinate)!
    }

    
    

}
