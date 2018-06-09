//
//  AlertHelper.swift
//  Sword
//
//  Created by Muhammed Karakul on 3.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: completion)
    }
    
    func alertWithOkButton(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okeyAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okeyAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func alertWithAction(title: String, message: String, action: UIAlertAction){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        let defaultAction = action
//        let cancelAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.cancel, handler: nil)
//        alertController.addAction(defaultAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
}
