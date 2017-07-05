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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.delegate = self
        passwordTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    

    
    @IBAction func loginBtnPressed(_ sender: Any) {
        isLoading(isLoading: true)
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
    }
    @IBAction func signUpBtnPressed(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.udacity.com/account/auth#!/signup")! as URL, options: [:], completionHandler: nil)
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

