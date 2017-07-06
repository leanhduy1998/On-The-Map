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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addPinBtn: UIBarButtonItem!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var loadingDataLabel: UILabel!
    
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    @IBAction func unwindBackToMapview(segue: UIStoryboardSegue){
        
    }
    func isLoading(loading: Bool){
        view.isUserInteractionEnabled = !loading
        loadingDataLabel.isHidden = !loading
        refreshBtn.isEnabled = !loading
        addPinBtn.isEnabled = !loading
    }
    @IBAction func addPinBtnClicked(_ sender: Any) {
        if ParseConstant.userData.annotationObjectIdArr.count > 0 {
            let alertController = UIAlertController(title: "Your location already exist", message: "Do you want to override your location?", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Override", style: UIAlertActionStyle.default, handler: overrideAlertController))
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "AddAnnotationViewController", sender: self)
        }
    }
    private func overrideAlertController(action: UIAlertAction){
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
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        ParseClient.deleteSession(completeHandler: {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }

    @IBAction func refreshBtnPressed(_ sender: Any) {
        if (delegate?.isInternetAvailable())! {
            refreshData()
        }
        else {
            let alertController = UIAlertController(title: "Device is not connected to Internet", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    func refreshData(){
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations((delegate?.annotations)!)
    }
}
