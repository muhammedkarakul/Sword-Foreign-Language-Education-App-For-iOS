//
//  AlertHelper.swift
//  Sword
//
//  Created by Muhammed Karakul on 3.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

extension UIViewController {
    
//    internal func alert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    internal func alertWithAction(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: handler)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    internal func alertWithOkAndCancelAction(title: String, message: String, okButtonTitle: String? = "Tamam", cancelButtonTitle: String? = "Vazgeç", okButtonHandler: ((UIAlertAction) -> Void)? = nil, cancelButtonHandler: ((UIAlertAction) -> Void)? = nil ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: okButtonHandler)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: cancelButtonHandler)
        
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
