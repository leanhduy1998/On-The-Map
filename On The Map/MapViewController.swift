//
//  MapViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/19/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate  {
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!

    static var annotations = [MKAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ParseClient.getStudentsLocationMap { (result) in
            self.mapView.removeAnnotations(self.mapView.annotations)
            MapViewController.annotations = result!
            self.mapView.addAnnotations(MapViewController.annotations)
        }
        
        
        
    }
    @IBAction func addPinBtnClicked(_ sender: Any) {
        performSegue(withIdentifier: "AddAnnotationViewController", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        
        pinAnnotationView.isDraggable = false
        pinAnnotationView.canShowCallout = true
        pinAnnotationView.animatesDrop = true
    
        let infoButton = UIButton(type: UIButtonType.custom)
        infoButton.frame.size.width = 33
        infoButton.frame.size.height = 33
        infoButton.setImage(UIImage(named: "info"), for: .normal)
        
        pinAnnotationView.leftCalloutAccessoryView = infoButton
        
        return pinAnnotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation {
            UIApplication.shared.open(NSURL(string: annotation.subtitle!!)! as URL, options: [:], completionHandler: nil)
        }
    }
}
