//
//  LoginViewController.swift
//  DanalMobile
//
//  Created by BENJAMIN BRYANT BUDIMAN on 05/09/18.
//  Copyright © 2018 Danal, Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if usernameTextField.text == "apple" && passwordTextField.text == "demo" {
            (UIApplication.shared.delegate as? AppDelegate)?.isDemo = true
            return true
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMdd"
            if passwordTextField.text == "\(usernameTextField.text?.lowercased().prefix(3) ?? "")\(dateFormatter.string(from: Date()))" {
                return true
            } else {
                let alertController = UIAlertController(title: "Authentication Failed", message: "The username or password you supplied was not correct.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
                return false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
            if shouldPerformSegue(withIdentifier: "logIn", sender: self) {
                performSegue(withIdentifier: "logIn", sender: self)
            }
            return false
        }
        return true
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}
