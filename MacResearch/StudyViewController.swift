//
//  StudyViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 19/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit
import AlamofireImage
import GTToast

class StudyViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var studyImageView: UIImageView!
    
    var toast: GTToastView!
    
    public var studyId: String?
    var study: Study!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        StudyService.getStudyMedia(study: study) {
            [weak self] (media, error) in
            
            if let error = error {
                debugPrint(error)
            } else {
                DispatchQueue.main.async(execute: {
                    if let weakSelf = self, let image = media as? UIImage {
                        weakSelf.studyImageView.image = image
                    }
                })
            }
        }
        
        titleTextField.text = study.name
        descriptionTextField.text = study.studyDescription
    }
    
    // MARK: IBActions
    
    @IBAction func registerInterest() {
        
        LoadingIndicator.show(targetView: view)
        
        StudyService.registerInterest(studyId: studyId!, completion: {
            
            (error) in
            
            LoadingIndicator.hide()
            
            if let _ = error {
                self.registerAlertShow(registerInterestFailed)
                return
            }
            self.registerAlertShow(registerInterestSuccess)
        })
    }
    
    func registerAlertShow(_ message: String) {
        let config = GTToastConfig(
            contentInsets: UIEdgeInsets(top:20, left: 30, bottom: 20, right: 30),
            font: UIFont.systemFont(ofSize: 14),
            textColor: UIColor.white,
            textAlignment: NSTextAlignment.left,
            backgroundColor: UIColor.black,
            displayInterval: 3
        )
        
        let image: UIImage? = .none
        
        toast = GTToast.create(message,
                               config: config,
                               image: image)
        toast.show()

    }
    
    @IBAction func referMyself() {
        
    }
    
    @IBAction func referFriend() {
        
    }
    
    @IBAction func logoutButtonPressed() {
        UserService.logOut()
    }
    
    @IBAction func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
