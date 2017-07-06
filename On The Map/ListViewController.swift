//
//  TableViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/20/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.studentsAsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell", for: indexPath) as? StudentViewCell
        let currentStudent = delegate!.studentsAsList[indexPath.row]
        cell?.studentNameLabel.text = currentStudent.keys.first

        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = delegate!.studentsAsList[indexPath.row]
        if(currentStudent.values.first?.isEmpty)!{
            
        }
        else {
            UIApplication.shared.open(NSURL(string: currentStudent.values.first!)! as URL, options: [:], completionHandler: nil)
        }

    }
    @IBAction func addPinBtnPressed(_ sender: Any) {
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
    @IBAction func refreshBtnPressed(_ sender: Any) {
        refreshData()
    }
    private func refreshData(){
        if (delegate?.isInternetAvailable())! {
            ParseClient.getStudentsLocationsAsList(completeHandler: { (studentsArr) in
                self.delegate!.studentsAsList = studentsArr
                self.tableView.reloadData()
            })
        }
        else {
            let alertController = UIAlertController(title: "Device is not connected to Internet", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }



}
