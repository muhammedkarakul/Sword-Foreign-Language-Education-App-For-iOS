//
//  UIViewController+BlurEffect.swift
//  Sword
//
//  Created by Muhammed Karakul on 11.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

extension UIViewController {
    var blurEffectTag: Int { return 888 }
    
    func showBlurView(withBlurEffectStyle style: UIBlurEffectStyle = .light , andCompletion completion: ((Bool) -> Void)? = nil) {
        
        DispatchQueue.main.async{
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurEffectView.alpha = 0.0
            blurEffectView.tag = self.blurEffectTag
            self.view.addSubview(blurEffectView)
            
            UIView.animate(withDuration: 0.2, animations: {
                blurEffectView.alpha = 1.0
            }, completion: completion)
        }
        
    }
    
    func hideBlurView() {
        DispatchQueue.main.async {
            if let blurEffectView = self.view.subviews.filter({
                $0.tag == self.blurEffectTag
            }).first as? UIVisualEffectView {
                
                UIView.animate(withDuration: 0.2, animations: {
                    blurEffectView.alpha = 0.0
                }, completion: { (_) in
                    blurEffectView.removeFromSuperview()
                })
                
            }
        }
    }
}
