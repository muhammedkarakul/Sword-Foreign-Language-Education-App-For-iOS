//
//  UIViewController+activityIndicatorStatus.swift
//  Sword
//
//  Created by Muhammed Karakul on 1.07.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var activityIndicatorTag: Int { return 999 }
    
    func startActivityIndicator(
        style: UIActivityIndicatorView.Style = .whiteLarge,
        location: CGPoint? = nil
        ) {
        
        self.view.isUserInteractionEnabled = false
        
        let loc = location ?? self.view.center
        
        DispatchQueue.main.async{
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        
        self.view.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter({
                $0.tag == self.activityIndicatorTag
            }).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
