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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapview.addAnnotation(annotation)
        mapview.centerCoordinate = annotation.coordinate
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapview.centerCoordinate =
            (userLocation.location?.coordinate)!
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        manager.startUpdatingLocation()
        self.mapview.showsUserLocation = true
        print(status)
    }
    
    

}
