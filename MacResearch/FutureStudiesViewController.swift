//
//  FutureStudiesViewController.swift
//  MacResearch
//
//  Created by Simon Rowlands on 18/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class FutureStudiesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellIdentifier = "studyCell"
    
    var studyArray = [Study]()
    var selectedStudy = Study(id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudyArray()
    }
    
    func getStudyArray() {
        StudyService.getStudies(status: .upcoming, completion: {
            
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
                    
                    self.studyArray = studies
                    self.collectionView.reloadData()
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
    
    
    // MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studyArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! StudyCollectionCell
        
        cell.titleLabel.text = studyArray[indexPath.row].name
        cell.buttonPressedCallback = {
            self.selectedStudy = self.studyArray[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 0
        
        width = (collectionView.frame.size.width - 40) / 2
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showStudySegue")
        {
            if let destinationVC = segue.destination as? StudyViewController {
                destinationVC.study = self.selectedStudy
            }
        }
    }
    

    
}
