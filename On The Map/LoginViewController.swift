//
//  ViewController.swift
//  On The Map
//
//  Created by Duy Le on 6/15/17.
//  Copyright © 2017 Andrew Le. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ParseConstant.applicationID != "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr" || ParseConstant.RESTAPIKey != "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY" {
            showAlert(title: "Wrong Application ID or REST API Key", message: "Please check your Application ID and REST API Key again!")
        }
        subscribeToKeyboardNotifications()
        isLoading(isLoading: false)
    }
    

    @IBAction func loginBtnPressed(_ sender: Any) {
        isLoading(isLoading: true)
        if !ParseClient.isInternetAvailable() {
            showAlert(title: "Internet Connection Not Available", message: "Please connect to the internet!")
        }
        if validateTFs() == true {
            UdacityClient.login(username: usernameTF.text!, password: passwordTF.text!, completionHandler: {title, message in
                if title.isEmpty {
                    DispatchQueue.main.async {
                        self.isLoading(isLoading: false)
                        self.performSegue(withIdentifier: "TabViewController", sender: self)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.isLoading(isLoading: false)
                        self.showAlert(title: title, message: message)
                    }
                }
            })
        }
    }
    func isLoading(isLoading: Bool){
        usernameTF.isEnabled = !isLoading
        passwordTF.isEnabled = !isLoading
        loginBtn.isEnabled = !isLoading
        activityIndicator.isHidden = !isLoading
        
        if isLoading {
           activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.udacity.com/account/auth#!/signup")! as URL, options: [:], completionHandler: nil)
    }
    
    func validateTFs() -> Bool{
        if (usernameTF.text?.isEmpty)! {
            showAlert(title: UdacityConstant.LoginError.usernameTitle, message: UdacityConstant.LoginError.usernameMessage)
            isLoading(isLoading: false)
            return false
        }
        else if (passwordTF.text?.isEmpty)! {
            showAlert(title: UdacityConstant.LoginError.passwordTitle, message: UdacityConstant.LoginError.passwordMessage)
            isLoading(isLoading: false)
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

extension LoginViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        loginBtnPressed(self)
        return true
    }
    func keyboardWillShow(_ notification:Notification) {
        if usernameTF.isEditing || passwordTF.isEditing {
            view.frame.origin.y -=  getKeyboardHeight(notification)
        }
    }
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
}
