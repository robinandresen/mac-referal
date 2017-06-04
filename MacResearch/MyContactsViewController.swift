//
//  MyContactsViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class MyContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "contactCell"
    
    var contactArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getContactArray()
        
    }
    
    func getContactArray() {
        ContactService.getContactArray(completion: {
            (json, error) in
            
            LoadingIndicator.hide()
            
            if let error = error {
                
                debugPrint(error)
                
            }else if let objects = json {
                
                var contacts = [User]()
                
                for object in objects {
               
                    let contact = User(email: "", accessToken: "")
                    
                    contact.email = object["email"] as! String?
                    contact.name = object["name"] as? String
                    
                    contacts.append(contact)
                }
                
                self.contactArray = contacts
                self.tableView.reloadData()
               
            }
            
            
        })
        
    }
    
    
    // MARK: IBActions
    
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
        return contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    //    let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactsCell
        
        cell.titleLabel?.text = contactArray[indexPath.section].name
        cell.emailLabel?.text = contactArray[indexPath.section].email
        
        return cell
    }
}
