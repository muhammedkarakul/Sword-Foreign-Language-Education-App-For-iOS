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

    internal var headerView = CustomOverlayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeaderView()
    }
    
    func setupHeaderView() {
        // Add headerView to view
        headerView = Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?.first as! CustomOverlayView
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        
        self.view.addSubview(headerView)
        
        let device = Device()
        
        if device == .iPhoneX {
            // Eğer mobil cihaz iphone x modeli ise üstten 50 pixel boşluk bırak.
            headerView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 60)
        } else {
            // Eğer mobil cihaz diğer iphone modelleriyse boşluk bırakmadan headerView'ı konumlandır.
            headerView.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: 60)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
