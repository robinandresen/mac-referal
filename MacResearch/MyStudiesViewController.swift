//
//  MyStudiesViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class MyStudiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let awaitingEligibilityIdentifier = "awaitingEligibilityCell"
    
    var awaitingEligibilityArray = [Study]()
    
    @IBOutlet weak var tableView: UITableView!

    var selectedStudy = Study(id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudyArray()
        
    }
    
    func getStudyArray() {
        StudyService.getStudies(status: .mine, completion: {
            
            (json, error) in
            
            LoadingIndicator.hide()
            
            if let error = error {
                
                debugPrint(error)
                
            }else{
                if let objects = json {
                    var studies = [Study]()
                    for object in objects {
                        let study = Study(json: object)
                        studies.append(study)
                    }
                    
                    self.awaitingEligibilityArray = studies
                    self.tableView.reloadData()
                  
                }
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
        //tableView.deselectRow(at: indexPath, animated: false)
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
        return awaitingEligibilityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   //     let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: awaitingEligibilityIdentifier, for: indexPath) as! AwaitingEligibilityCell
        
        cell.titleLabel.text = self.awaitingEligibilityArray[indexPath.section].name
        
        return cell
    }

}
