//
//  EligibilityFormViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 19/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class EligibilityFormViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var questionList = [String]()
    
    let yesNoIdentifier = "yesNoCell"
    let dateSelectIdentifier = "dateSelectCell"
    let sliderIdentifier = "sliderCell"
    let dropdownIdentifier = "dropdownCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionList = ["Question 1", "Question 2"]
    }
    
    
    // MARK: IBActions
    
    @IBAction func submitForm() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
    }
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        //
       // switch tableView {
      //  case :
     //
    //    default:
   //
  //      }

        let cell = tableView.dequeueReusableCell(withIdentifier: yesNoIdentifier, for: indexPath) as! YesNoCell
        
        cell.titleLabel?.text = questionList[section]
        
        return cell
    }
    
}
