//
//  MapViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/19/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController  {
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseClient.setup(mapview: mapView)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseClient.getStudentsLocation()
    }
    
    

}
