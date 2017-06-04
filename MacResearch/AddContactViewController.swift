//
//  AddContactViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 19/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    var newContact = User(email: "", accessToken: "")
    
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    // MARK: IBActions
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
    }
    
    @IBAction func onAddContact(_ sender: AnyObject) {
        
        if let email = emailTextField.text {
            
            newContact.email = email
            
            ContactService.addNewContact(contact: newContact, completion: {
                (json, error) in
                
                LoadingIndicator.hide()
                
                if let error = error {
                    
                    debugPrint(error)
                    
                    if error.code == 422 {
                        let weakSelf = self
                        
                        let confirmationAlert = UIAlertController(title: nil, message: "The selected email is valid", preferredStyle: .alert)
                        confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        weakSelf.present(confirmationAlert, animated: true, completion: nil)
                    }
                    
                    if error.code == 409 {
                        let weakSelf = self
                        
                        let confirmationAlert = UIAlertController(title: nil, message: " Contact is already in your contacts list", preferredStyle: .alert)
                        confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        weakSelf.present(confirmationAlert, animated: true, completion: nil)
                    }
                    
                }else if let contact = json {
                    
                    self.newContact.email = contact["email"] as? String
                    self.newContact.name = contact["name"] as? String
                        
                }
                
            })
            
        } else {
            
            let weakSelf = self
            
            let confirmationAlert = UIAlertController(title: nil, message: "Please wirte the email", preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            weakSelf.present(confirmationAlert, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: TextFields
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
