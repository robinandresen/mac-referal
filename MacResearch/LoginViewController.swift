//
//  LoginViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 17/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var switchSecurityButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserService.loadCurrentUser()
        
        if let _ = UserService.sharedInstance.currentUser?.accessToken {
            
            LoadingIndicator.show(targetView: view)
            
            UserService.signIn(completion: {
                (error) in
                
                LoadingIndicator.hide()
                
                if let _ = error {
                    
                } else {
                    self.performSegue(withIdentifier: "showDashboard", sender: self)
                }
            })
        }
    }
    
    func completion(error: NSError?) {
        LoadingIndicator.hide()
        
        if let _ = error {
            
        } else {
            self.performSegue(withIdentifier: "showDashboard", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBActions
    
    @IBAction func switchSecurePassword() {
        
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            switchSecurityButton.titleLabel?.text = "HIDE"
        }else{
            passwordTextField.isSecureTextEntry = true
            switchSecurityButton.titleLabel?.text = "SHOW"
        }
    }
    
    @IBAction func loginButtonPressed() {
        
        guard emailTextField.text != "", let email = emailTextField.text, passwordTextField.text != "", let password = passwordTextField.text else {
            
            let alert = UIAlertController(title: "Error", message: "Please fill in both the password and email fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.passwordTextField.text = ""
            }))
            
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        LoadingIndicator.show(targetView: view)
        
        UserService.getAccessToken(email: email, password: password, completion: {
            [weak self] (error) in
            
            if let weakSelf = self, let error = error, let errorInfo = error.userInfo as? [String: String] {
                
                LoadingIndicator.hide()
                
                let alert = UIAlertController(title: "Error", message: errorInfo["message"], preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                    weakSelf.passwordTextField.text = ""
                }))
                
                weakSelf.present(alert, animated: true, completion: nil)
                
            }else if let _ = UserService.sharedInstance.currentUser, let weakSelf = self {
                
                if let _ = UserService.sharedInstance.currentUser?.accessToken {
                    
                    UserService.signIn(completion: {
                        [weak self] (error) in
                        
                        LoadingIndicator.hide()
                        
                        if let error = error, let weakSelf = self, let errorInfo = error.userInfo as? [String: String] {
                            
                            debugPrint(error)
                            let alert = UIAlertController(title: "Error", message: errorInfo["message"], preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                                weakSelf.passwordTextField.text = ""
                            }))
                            
                            weakSelf.present(alert, animated: true, completion: nil)
                            
                        }else{
                            weakSelf.passwordTextField.text = ""
                            weakSelf.performSegue(withIdentifier: "showDashboard", sender: weakSelf)
                        }
                    })
                }
                
            }else{
                LoadingIndicator.hide()
            }
        })
        
    }
    
    @IBAction func forgotPasswordPressed() {
        
    }
    
    
    @IBAction func resetPasswordPressed() {
        
    }
    
    // MARK: TextFields
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    // MARK: Segues
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
}
