//
//  RegisterViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 17/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit
import AETextFieldValidator
import WWCalendarTimeSelector



class RegisterViewController: UIViewController, UITextFieldDelegate, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var nameTextField: AETextFieldValidator!
    @IBOutlet weak var dateOfBirthTextField: AETextFieldValidator!
    @IBOutlet weak var addressTextField: AETextFieldValidator!
    @IBOutlet weak var townTextField: AETextFieldValidator!
    @IBOutlet weak var countyTextField: AETextFieldValidator!
    @IBOutlet weak var postcodeTextField: AETextFieldValidator!
    @IBOutlet weak var emailTextField: AETextFieldValidator!
    @IBOutlet weak var phoneTextField: AETextFieldValidator!
    @IBOutlet weak var passwordTextField: AETextFieldValidator!
    @IBOutlet weak var confirmPasswordTextField: AETextFieldValidator!
    @IBOutlet weak var commentsTextField: AETextFieldValidator!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var datePicker = UIDatePicker()
    
    var selectedDate = Date()
    
    var isSubscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        
        datePicker.addTarget(self, action: #selector(setDateFromPicker), for: UIControlEvents.valueChanged)
        
        
        
        setupAlerts()
       
    }
    
    func setupAlerts() {
        
        nameTextField.addRegx(REGEX_USER_NAME_LIMIT, withMsg: "User name charaters limit should be come between 3-10")
        nameTextField.addRegx(REGEX_USER_NAME, withMsg: "Only alpha numeric characters are allowed.")
        nameTextField.mandatoryInvalidMsg = "This field is required"
        nameTextField.popUpCornerRadius = 5.0
        
        addressTextField.mandatoryInvalidMsg = "This field is required"
        addressTextField.popUpCornerRadius = 5.0
        
        dateOfBirthTextField.mandatoryInvalidMsg = "This field is required"
        dateOfBirthTextField.popUpCornerRadius = 5.0
        
        
        postcodeTextField.addRegx(REGEX_POSTCODE_LIMIT, withMsg: "Postcode charaters limit should be come between 4-10")
        postcodeTextField.addRegx(REGEX_POSTCODE, withMsg: "Only numeric characters are allowed.")
        postcodeTextField.mandatoryInvalidMsg = "This field is required"
        postcodeTextField.popUpCornerRadius = 5.0
        
        emailTextField.addRegx(REGEX_EMAIL, withMsg: "Enter valid email.")
        emailTextField.mandatoryInvalidMsg = "This field is required"
        emailTextField.popUpCornerRadius = 5.0
        
        phoneTextField.addRegx(REGEX_PHONE_DEFAULT, withMsg:  "Only numeric characters are allowed.")
        phoneTextField.mandatoryInvalidMsg = "This field is required"
        phoneTextField.popUpCornerRadius = 5.0
        
        passwordTextField.mandatoryInvalidMsg = "This field is required"
        passwordTextField.popUpCornerRadius = 5.0
        
        confirmPasswordTextField.addConfirmValidation(to: passwordTextField, withMsg: "Confirm password didn't match.")
        confirmPasswordTextField.popUpCornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    @IBAction func registerButtonPressed() {
        
        if nameTextField.validate() && dateOfBirthTextField.validate() && addressTextField.validate() && postcodeTextField.validate() && phoneTextField.validate()  && passwordTextField.validate() && confirmPasswordTextField.validate(){
            
            var postDict = [String : Any]()
            
            var boolNumber = 0
            if isSubscribed {
                boolNumber = 1
            }
            postDict["subscribed_to_newsletter"] = boolNumber
            
            if UserService.sharedInstance.currentUser?.role == .volunteer {
                postDict["user_type"] = "volunteer"
            }else{
                postDict["user_type"] = "healthcare_professional"
            }
            
            postDict["name"] = nameTextField.text
            postDict["email"] = emailTextField.text
            postDict["address"] = addressTextField.text
            postDict["town_city"] = townTextField.text
            postDict["county"] = countyTextField.text
            postDict["postcode"] = postcodeTextField.text
            postDict["telephone_number"] = phoneTextField.text
            postDict["date_of_birth"] = dateOfBirthTextField.text
            postDict["password"] = passwordTextField.text
            postDict["password_confirmation"] = confirmPasswordTextField.text
            postDict["comments"] = commentsTextField.text
            
            LoadingIndicator.show(targetView: view)
            
            UserService.registerUser(params: postDict, completion: {
                [weak self] (error) in
                
                LoadingIndicator.hide()
                
                if let error = error {
                    if let weakSelf = self, let errorInfo = error.userInfo.first?.1 as? [String] {
                        let confirmationAlert = UIAlertController(title: nil, message: errorInfo.first, preferredStyle: .alert)
                        confirmationAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        weakSelf.present(confirmationAlert, animated: true, completion: nil)
                    }
                    
                    debugPrint("error - \(error)")
                } else if let _ = UserService.sharedInstance.currentUser, let weakSelf = self {
                    
                    if UserService.sharedInstance.currentUser?.role == .volunteer {
                        
                        weakSelf.performSegue(withIdentifier: "showMedication", sender: weakSelf)
                        
                    } else {
                    
                        weakSelf.performSegue(withIdentifier: "showDirectDashboard", sender: weakSelf)
                    }
                    
                } else {
                    
                    debugPrint("Register succeeded but no user?")
                }
                
            })


            
        }
        

 
        
    }
    
    @IBAction func subscribeButtonPressed() {
        isSubscribed = !isSubscribed
    }
    
    @IBAction func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height = UIScreen.main.bounds.size.height - keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.size.height = UIScreen.main.bounds.size.height
    }
    
    // MARK: TextFields
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == dateOfBirthTextField {
            setDateFromPicker()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case nameTextField:
            dateOfBirthTextField.becomeFirstResponder()
        case dateOfBirthTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            townTextField.becomeFirstResponder()
        case townTextField:
            countyTextField.becomeFirstResponder()
        case countyTextField:
            postcodeTextField.becomeFirstResponder()
        case postcodeTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            commentsTextField.becomeFirstResponder()
        case commentsTextField:
            commentsTextField.resignFirstResponder()
        default:
            break
        }
        
        return false
    }
    
    // MARK: DatePicker
    
    func setDateFromPicker() {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateString = dateFormatter.string(from: datePicker.date)
        dateOfBirthTextField.text = dateString
    }
    
}
