//
//  AddLinkToAnnotationViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/23/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import MapKit

class AddLinkToAnnotationViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    
    var annotation = MKPointAnnotation()
    var mapString = String()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapview.addAnnotation(annotation)
        mapview.centerCoordinate = annotation.coordinate
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        annotation.subtitle = linkTF.text
        
        if ParseConstant.userData.annotationObjectIdArr.count > 0 {
            var sent = false
            for objectId in ParseConstant.userData.annotationObjectIdArr {
                ParseClient.putStudentLocation(objectId: objectId, mapString: mapString, mediaURL: linkTF.text!, latitude: annotation
                    .coordinate.latitude, longitude: annotation.coordinate.longitude, handleResult: { error in
                        if error.isEmpty {
                            if !sent {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "unwindBackToMapview", sender: self)
                                }
                                sent = true
                            }
                        }
                        else {
                            let alertController = UIAlertController(title: "Error updating your location!", message: error, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                })
            }
        }
        else {
            ParseClient.postStudentLocation(mapString: mapString, mediaURL: linkTF.text!, latitude: annotation
                .coordinate.latitude, longitude: annotation.coordinate.longitude) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "unwindBackToMapview", sender: self)
                    }
            }
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapview.centerCoordinate =
            (userLocation.location?.coordinate)!
    }

    
    

}
