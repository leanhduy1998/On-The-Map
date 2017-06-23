//
//  addAnnotationViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/22/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class AddAnnotationViewController: UIViewController {
    @IBOutlet weak var searchTF: UITextField!

    private var annotation = MKPointAnnotation()
    @IBAction func findBtnPressed(_ sender: Any) {
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchTF.text
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }

            self.annotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            print(self.annotation.coordinate)
        }
        performSegue(withIdentifier: "AddLinkToAnnotationViewController", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddAnnotationViewController {
            destination.annotation = self.annotation
        }
    }
    
    

}
