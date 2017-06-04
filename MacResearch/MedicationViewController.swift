//
//  MedicationViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class MedicationViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var selectedMedications = [String]()
    var medicationsList = [String]()
    var medicationsMatchingList = [String]()

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchFieldContainerView: UIView!

    @IBOutlet weak var searchResultsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectedMedicationTableView: UITableView!

    let selectedMedicationIdentifier = "medicationCell"
    let searchResultsIdentifier = "searchResultsCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        medicationsList = ["Aspartame", "Asparaginase", "Aspartic Acid", "Asparton"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
    }
    
    @IBAction func textDidChangeInSearch() {
        
        medicationsMatchingList = []
        
        if let charactersInField = searchTextField.text, charactersInField.characters.count >= 3 {
            
            let items = medicationsList.filter({$0.range(of: charactersInField, options: .caseInsensitive) != nil})
            
                medicationsMatchingList = items
            
            if searchResultView.isHidden, medicationsMatchingList.count > 0 {
                searchResultView.isHidden = false
                
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: searchTextField.frame.origin.y) , animated: true)
                
            }else if medicationsMatchingList.count == 0 {
                searchResultView.isHidden = true
            }
            
            searchResultsTableView.reloadData()
            
        }else{
            searchResultView.isHidden = true
        }
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            searchResultsHeightConstraint.constant = view.frame.height - (searchFieldContainerView.frame.maxY + scrollView.frame.origin.y + keyboardSize.height + 2)
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: searchTextField.frame.origin.y) , animated: true)
        }
    }
    
    // MARK: TextFields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let charactersInField = searchTextField.text, charactersInField.characters.count >= 3 {
            searchResultView.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchResultView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return false
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView == selectedMedicationTableView {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, tableView == selectedMedicationTableView {
            tableView.beginUpdates()
            
            selectedMedications.remove(at: indexPath.section)
            
            tableView.deleteSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
            
            tableViewHeightConstraint.constant = selectedMedicationTableView.contentSize.height
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchResultsTableView {
            let section = indexPath.section
            
            let medicationSelected = medicationsList[section]
            let itemsSelected = selectedMedications.filter({
                $0.range(of: medicationSelected, options: .caseInsensitive) != nil
            })
            
            if itemsSelected.count == 0 {
                selectedMedications.append(medicationSelected)
            }
            
            selectedMedicationTableView.reloadData()
            
            tableViewHeightConstraint.constant = selectedMedicationTableView.contentSize.height
            
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
        
        if tableView == selectedMedicationTableView{
            return selectedMedications.count
        }
        
        return medicationsMatchingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if tableView == selectedMedicationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: selectedMedicationIdentifier, for: indexPath) as! MedicationCell
            
            cell.medicationTitleLabel?.text = selectedMedications[section]
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: searchResultsIdentifier, for: indexPath) as! SearchResultsCell
            
            cell.titleLabel?.text = medicationsMatchingList[section]
            
            return cell
        }
    }
    
}
