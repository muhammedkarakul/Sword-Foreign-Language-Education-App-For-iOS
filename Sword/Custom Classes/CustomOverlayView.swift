//
//  CustomOverlayView.swift
//  Sword
//
//  Created by Muhammed Karakul on 18.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "overlay_skip"
private let overlayLeftImageName = "overlay_like"

class CustomOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in

        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)

        return imageView
        }()


    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }

        }
    }
}
