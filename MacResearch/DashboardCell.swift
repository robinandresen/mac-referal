//
//  DashboardCell.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    var buttonPressedCallback: (() -> ())?
    
    @IBAction func buttonPressed() {
        
        if let callback = buttonPressedCallback {
            callback()
        }
    }
}
