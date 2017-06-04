//
//  UserProfileViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

enum ProfilePages: Int {
    case detail = 0
    case medication
    case medicalIndicator
    case notification
}

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var selectedMedications = [String]()
    var medicationsList = [String]()
    var medicationsMatchingList = [String]()
    
    @IBOutlet weak var medicationTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var medicationSearchTextField: UITextField!
    @IBOutlet weak var medicationSearchFieldContainerView: UIView!
    @IBOutlet weak var medicationSearchResultsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var medicationSearchResultView: UIView!
    @IBOutlet weak var medicationSearchResultsTableView: UITableView!
    @IBOutlet weak var medicationScrollView: UIScrollView!
    
    @IBOutlet weak var medicationSelectedTableView: UITableView!
    
    var selectedMedicalIndicators = [String]()
    var medicalIndicatorsList = [String]()
    var medicalIndicatorsMatchingList = [String]()
    
    @IBOutlet weak var medicalIndicatorsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var medicalSearchTextField: UITextField!
    @IBOutlet weak var medicalSearchFieldContainerView: UIView!
    @IBOutlet weak var medicalSearchResultsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var medicalSearchResultView: UIView!
    @IBOutlet weak var medicalSearchResultsTableView: UITableView!
    @IBOutlet weak var medicalScrollView: UIScrollView!
    
    @IBOutlet weak var medicalSelectedTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var townTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    
    var isSubscribed = false
    
    
    let medicationSelectedIdentifier = "medicationCell"
    let medicationSearchResultsIdentifier = "medicationSearchCell"
    
    let medicalIndicatorSelectedIdentifier = "medicalIndicatorCell"
    let medicalIndicatorSearchResultsIdentifier = "medicalIndicatorSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        medicationsList = ["Asp1", "Asp2", "Asp3"]
        medicalIndicatorsList = ["Med1", "Med2", "Med3"]
        
        initTextFields()
    }
    
    func initTextFields(){
        
        nameTextField.text = UserService.sharedInstance.currentUser?.name
        addressTextField.text = UserService.sharedInstance.currentUser?.address
        townTextField.text = UserService.sharedInstance.currentUser?.townCity
        countryTextField.text = UserService.sharedInstance.currentUser?.county
        postcodeTextField.text = UserService.sharedInstance.currentUser?.postcode
        emailTextField.text = UserService.sharedInstance.currentUser?.email
        phoneTextField.text = UserService.sharedInstance.currentUser?.telephoneNumber
        commentsTextField.text = UserService.sharedInstance.currentUser?.comments
        
        if let subscribedToNewsletter = UserService.sharedInstance.currentUser?.subscribedToNewsletter {
            
            isSubscribed = subscribedToNewsletter
            
        }
    }
    
    
    // MARK: IBActions
    
    @IBAction func onCheckSubscirbe(_ sender: AnyObject) {

        isSubscribed = !isSubscribed

    }

    @IBAction func onClickSave(_ sender: AnyObject) {
        
        guard emailTextField.text != "" else {
            return
        }
        
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
        postDict["county"] = countryTextField.text
        postDict["postcode"] = postcodeTextField.text
        postDict["telephone_number"] = phoneTextField.text
        postDict["comments"] = commentsTextField.text
        
        LoadingIndicator.show(targetView: view)
        
        UserService.updateUser(params: postDict, completion: {
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
                
                let confirmationAlert = UIAlertController(title: nil, message: updateUserSuccess, preferredStyle: .alert)
                confirmationAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                weakSelf.present(confirmationAlert, animated: true, completion: nil)
            } else {
                debugPrint("Register succeeded but no user?")
            }
            
            })
        
    }
    
    @IBAction func textDidChangeInMedicationSearch() {
        
        medicationsMatchingList = []
        
        if let charactersInField = medicationSearchTextField.text, charactersInField.characters.count >= 3 {
            
            let items = medicationsList.filter({$0.range(of: charactersInField, options: .caseInsensitive) != nil})
            
            medicationsMatchingList = items
            
            if medicationSearchResultView.isHidden, medicationsMatchingList.count > 0 {
                medicationSearchResultView.isHidden = false
                
                medicationScrollView.setContentOffset(CGPoint(x: medicationScrollView.contentOffset.x, y: medicationSearchTextField.frame.origin.y) , animated: true)
                
            }else if medicationsMatchingList.count == 0 {
                medicationSearchResultView.isHidden = true
            }
            
            medicationSearchResultsTableView.reloadData()
            
        }else{
            medicationSearchResultView.isHidden = true
        }
    }
    
    @IBAction func textDidChangeInMedicalSearch() {
        
        medicalIndicatorsMatchingList = []
        
        if let charactersInField = medicalSearchTextField.text, charactersInField.characters.count >= 3 {
            
            let items = medicalIndicatorsList.filter({$0.range(of: charactersInField, options: .caseInsensitive) != nil})
            
            medicalIndicatorsMatchingList = items
            
            if medicalSearchResultView.isHidden, medicalIndicatorsMatchingList.count > 0 {
                medicalSearchResultView.isHidden = false
                
                medicalScrollView.setContentOffset(CGPoint(x: medicalScrollView.contentOffset.x, y: medicalSearchTextField.frame.origin.y) , animated: true)
                
            }else if medicalIndicatorsMatchingList.count == 0 {
                medicalSearchResultView.isHidden = true
            }
            
            medicalSearchResultsTableView.reloadData()
            
        }else{
            medicalSearchResultView.isHidden = true
        }
    }
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
    }
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectProfilePageButtonPressed(_ sender: UIButton?) {
        self.selectProfilePageWith(index: (sender?.tag)!)
    }
    
    // MARK:
    func selectProfilePageWith(index: Int) {
        let width = self.scrollView.frame.size.width
        let offset = CGPoint(x: CGFloat(index) * width, y: 0)
        self.scrollView.setContentOffset(offset, animated: true)
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            medicationSearchResultsHeightConstraint.constant = view.frame.height - (medicationSearchFieldContainerView.frame.maxY + medicationScrollView.frame.origin.y + keyboardSize.height + 2)
            medicationScrollView.setContentOffset(CGPoint(x: medicationScrollView.contentOffset.x, y: medicationSearchTextField.frame.origin.y) , animated: true)
            
            medicalSearchResultsHeightConstraint.constant = view.frame.height - (medicalSearchFieldContainerView.frame.maxY + medicalScrollView.frame.origin.y + keyboardSize.height + 2)
            medicalScrollView.setContentOffset(CGPoint(x: medicalScrollView.contentOffset.x, y: medicalSearchTextField.frame.origin.y) , animated: true)
        }
    }
    
    // MARK: Text Fields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == medicationSearchTextField {
            if let charactersInField = medicationSearchTextField.text, charactersInField.characters.count >= 3 {
                medicationSearchResultView.isHidden = false
            }
        }else if textField == medicalSearchTextField {
            if let charactersInField = medicalSearchTextField.text, charactersInField.characters.count >= 3 {
                medicalSearchResultView.isHidden = false
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        medicationSearchResultView.isHidden = true
        medicalSearchResultView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }

    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView == medicationSelectedTableView || tableView == medicalSelectedTableView {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, tableView == medicationSelectedTableView || tableView == medicalSelectedTableView {
            
            tableView.beginUpdates()
            
            if tableView == medicationSelectedTableView {
                selectedMedications.remove(at: indexPath.section)
                medicationTableViewHeightConstraint.constant = medicationSelectedTableView.contentSize.height
            }else if tableView == medicalSelectedTableView {
                selectedMedicalIndicators.remove(at: indexPath.section)
                medicalIndicatorsTableViewHeightConstraint.constant = medicalSelectedTableView.contentSize.height
            }
            
            
            tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if tableView == medicationSearchResultsTableView {
            
            let medicationSelected = medicationsList[section]
            let itemsSelected = selectedMedications.filter({
                $0.range(of: medicationSelected, options: .caseInsensitive) != nil
            })
            
            if itemsSelected.count == 0 {
                selectedMedications.append(medicationSelected)
            }
            
            medicationSelectedTableView.reloadData()
            
            medicationTableViewHeightConstraint.constant = medicationSelectedTableView.contentSize.height
            
            view.endEditing(true)
            
        }else if tableView == medicalSearchResultsTableView {
            
            let medicalIndicatorsSelected = medicalIndicatorsList[section]
            let itemsSelected = selectedMedicalIndicators.filter({
                $0.range(of: medicalIndicatorsSelected, options: .caseInsensitive) != nil
            })
            
            if itemsSelected.count == 0 {
                selectedMedicalIndicators.append(medicalIndicatorsSelected)
            }
            
            medicalSelectedTableView.reloadData()
            
            medicalIndicatorsTableViewHeightConstraint.constant = medicalSelectedTableView.contentSize.height
            
            view.endEditing(true)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch tableView {
        case medicationSelectedTableView:
            return selectedMedications.count
            
        case medicalSelectedTableView:
            return selectedMedicalIndicators.count
            
        case medicationSearchResultsTableView:
            return medicationsMatchingList.count
            
        case medicalSearchResultsTableView:
            return medicalIndicatorsMatchingList.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        switch tableView {
        case medicationSelectedTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: medicationSelectedIdentifier, for: indexPath) as! MedicationCell
            
            cell.medicationTitleLabel?.text = selectedMedications[section]
            
            return cell
            
        case medicationSearchResultsTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: medicationSearchResultsIdentifier, for: indexPath) as! SearchResultsCell
            
            cell.titleLabel?.text = medicationsMatchingList[section]
            
            return cell
            
        case medicalSelectedTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: medicalIndicatorSelectedIdentifier, for: indexPath) as! MedicationCell
            
            cell.medicationTitleLabel?.text = selectedMedicalIndicators[section]
            
            return cell
            
        default:
            
            // medicalSearchResultsTableView
            
            let cell = tableView.dequeueReusableCell(withIdentifier: medicalIndicatorSearchResultsIdentifier, for: indexPath) as! SearchResultsCell
            
            cell.titleLabel?.text = medicalIndicatorsMatchingList[section]
            
            return cell
        }
    }
}
