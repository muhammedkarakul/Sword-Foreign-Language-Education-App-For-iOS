//
//  CustomMainViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 24.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import DeviceKit

class CustomMainViewController: CustomViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add headerView to view
        let headerView = Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?.first as? CustomOverlayView
        self.view.addSubview(headerView!)
        
        let device = Device()
        
        if device == .iPhoneX {
            // Eğer mobil cihaz iphone x modeli ise üstten 50 pixel boşluk bırak.
            headerView?.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 50)
        } else {
            // Eğer mobil cihaz diğer iphone modelleriyse boşluk bırakmadan headerView'ı konumlandır.
            headerView?.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 50)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}