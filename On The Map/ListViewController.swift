//
//  TableViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/20/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDataSource.sharedInstance.studentData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell", for: indexPath) as? StudentViewCell
        let currentStudent = StudentDataSource.sharedInstance.studentData[indexPath.row]
        
        
        if currentStudent.firstName == nil || currentStudent.lastName == nil {
            
        }
        else {
            cell?.studentNameLabel.text = "\(currentStudent.firstName.description) \(currentStudent.lastName.description)"
        }

        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = StudentDataSource.sharedInstance.studentData[indexPath.row]
        if(!currentStudent.mediaURL.isEmpty){
            UIApplication.shared.open(NSURL(string: currentStudent.mediaURL)! as URL, options: [:], completionHandler: { (completed) in
                if !completed {
                    let alertController = UIAlertController(title: "This link cannot be open", message: "This link is either incompleted or empty!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
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
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        ParseClient.deleteSession(completeHandler: {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    private func refreshData(){
        if (ParseClient.isInternetAvailable()) {
            ParseClient.getStudentsLocationsAsList(completeHandler: { (studentsArr) in
                DispatchQueue.main.async {
                    StudentDataSource.sharedInstance.studentData = studentsArr
                    self.tableView.reloadData()
                }
            })
        }
        else {
            let alertController = UIAlertController(title: "Device is not connected to Internet", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
