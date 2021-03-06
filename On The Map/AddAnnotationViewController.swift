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

class AddAnnotationViewController: UIViewController,UITextFieldDelegate  {
    @IBOutlet weak var searchTF: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    private var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func findBtnPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchTF.text
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
        localSearch.start { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            self.annotation.title = "\(UdacityConstant.userInfo.firstName.description) \(UdacityConstant.userInfo.lastName.description)"
            self.annotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)

            DispatchQueue.main.async {
                self.displayAddLink()
                self.activityIndicator.stopAnimating()
            }
        }
    }

    
    func displayAddLink(){
        performSegue(withIdentifier: "AddLinkToAnnotationViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddLinkToAnnotationViewController {
            destination.annotation = self.annotation
            destination.mapString = self.searchTF.text!
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}
