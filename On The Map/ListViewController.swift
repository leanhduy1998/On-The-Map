//
//  TableViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/20/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    static var studentsAsList = [[String:String]]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print(ListViewController.studentsAsList.count)
        ParseClient.getStudentsLocationsAsList(completeHandler: { (studentsArr) in
            ListViewController.studentsAsList = studentsArr
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListViewController.studentsAsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentViewCell", for: indexPath) as? StudentViewCell
        let currentStudent = ListViewController.studentsAsList[indexPath.row]
        cell?.studentNameLabel.text = currentStudent.keys.first

        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStudent = ListViewController.studentsAsList[indexPath.row]
        UIApplication.shared.open(NSURL(string: currentStudent.values.first!)! as URL, options: [:], completionHandler: nil)

    }



}
