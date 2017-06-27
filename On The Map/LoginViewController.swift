//
//  ViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBAction func loginBtnPressed(_ sender: Any) {
        if validateTFs() == true {
            UdacityClient.login(username: usernameTF.text!, password: passwordTF.text!, completionHandler: {title, message in
                if title.isEmpty {
                    DispatchQueue.main.async {
                        ParseClient.getStudentsLocationMap(completeHandler: { (annotations) in
                            MapViewController.annotations = annotations!
                            ParseClient.getStudentsLocationsAsList(completeHandler: { (studentList) in
                                ListViewController.studentsAsList = studentList
                                self.performSegue(withIdentifier: "TabViewController", sender: self)
                            })
                            UdacityClient.getUserPublicData()
                            
                        })
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.showAlert(title: title, message: message)
                    }
                }
            })
        }
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
    }
    @IBAction func signInFacebookBtnPressed(_ sender: Any) {
    }
    
    
    func validateTFs() -> Bool{
        if (usernameTF.text?.isEmpty)! {
            showAlert(title: UdacityConstant.LoginError.usernameTitle, message: UdacityConstant.LoginError.usernameMessage)
            return false
        }
        else if (passwordTF.text?.isEmpty)! {
            showAlert(title: UdacityConstant.LoginError.passwordTitle, message: UdacityConstant.LoginError.passwordMessage)
            return false
        }
        return true
    }
    func showAlert(title: String, message: String){
        let controller = UIAlertController()
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        controller.title = title
        controller.message = message
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        
    }
 
}

