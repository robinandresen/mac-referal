//
//  RoleSelectViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 17/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class RoleSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UserService.sharedInstance.currentUser = User(email: "", accessToken: "")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    
    @IBAction func healthCareProfessionalPressed() {
        
        UserService.sharedInstance.currentUser?.role = .healthCareProfessional
    }
    
    
    @IBAction func volunteerPressed() {
        
        UserService.sharedInstance.currentUser?.role = .volunteer
        
    }
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}

