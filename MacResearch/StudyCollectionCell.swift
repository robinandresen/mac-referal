//
//  StudyCollectionCell.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class StudyCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var buttonPressedCallback: (() -> ())?
    
    @IBAction func buttonPressed() {
        
        if let callback = buttonPressedCallback {
            callback()
        }
    }
}
