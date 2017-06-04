//
//  LoadingIndicator.swift
//  MacResearch
//
//  Created by Simon Rowlands on 24/01/2017.
//  Copyright © 2017 Appitized. All rights reserved.
//

import UIKit

class LoadingIndicator {
    
    var view = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    private static let sharedInstance = LoadingIndicator()
    
    static func show(targetView: UIView) {
        sharedInstance.show(targetView: targetView)
    }
    
    static func hide() {
        sharedInstance.hide()
    }
    
    func show(targetView: UIView) {
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        targetView.addSubview(view)
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        view.removeFromSuperview()
    }
}
