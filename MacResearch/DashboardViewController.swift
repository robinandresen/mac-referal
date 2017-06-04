//
//  DashboardViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "dashboardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: IBActions
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DashboardCell
        
        switch section {
        case 0:
            cell.titleLabel.text = "Live Studies"
            cell.descriptionLabel.text = "Live studies are updated at regular intervals"
            cell.buttonPressedCallback = {
                self.performSegue(withIdentifier: "showLiveStudies", sender: self)
            }
        case 1:
            cell.titleLabel.text = "Future Studies"
            cell.descriptionLabel.text = "Future studies are updated at regular intervals"
            cell.buttonPressedCallback = {
                self.performSegue(withIdentifier: "showFutureStudies", sender: self)
            }
        case 2:
            cell.titleLabel.text = "My Studies"
            cell.descriptionLabel.text = "My studies are updated at regular intervals"
            cell.buttonPressedCallback = {
                self.performSegue(withIdentifier: "showMyStudies", sender: self)
            }
        case 3:
            cell.titleLabel.text = "My Contacts"
            cell.descriptionLabel.text = "My Contacts can be viewed here"
            cell.buttonPressedCallback = {
                self.performSegue(withIdentifier: "showMyContacts", sender: self)
            }
        default: break
            
        }
        
        return cell
    }
}
