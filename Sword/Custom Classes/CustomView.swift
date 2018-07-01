//
//  CustomView.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Properties -
    
    private let profileImageView = UIImageView()
    private let userNameLabel = UILabel()
    private let userExperienceProgressBar = UIProgressView()
    private let scoreLabel = UILabel()
    private let levelLabel = UILabel()
    private let bottomLineView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.bounds.size.width = UIScreen.main.bounds.width
        
        setImageView(profileImageView)
        setUserNameLabel(userNameLabel)
        setUserExperienceProgressBar(userExperienceProgressBar)
        setScoreLabel(scoreLabel)
        setLevelLabel(levelLabel)
        setBottomLineView(bottomLineView)
        
    }
    
    private func setImageView (_ imageView: UIImageView) {
        // Settings imageview properties
        imageView.backgroundColor = UIColor.clear // sets background transparent
        imageView.frame.origin.x = 16 // sets imageview's x coordinate
        imageView.frame.origin.y = 2 // sets imageview's y coordinate
        imageView.frame.size.width = self.frame.size.height / 1.5 // sets imageview's width
        imageView.frame.size.height = self.frame.size.height / 1.5 // sets imageview's height
        imageView.contentMode = UIViewContentMode.scaleAspectFit // sets imageview's content mode = aspect fit
        imageView.image = UIImage.init(named: "avatar") // sets imageview's image with name
        
        // Round edges of the imageview
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = profileImageView.frame.height/2
        imageView.clipsToBounds = true
        
        // Add image view to subview
        self.addSubview(profileImageView)
    }
    
    private func setUserNameLabel(_ label: UILabel) {
        label.text = "kullanıcı adı"
        label.frame.origin.x = profileImageView.frame.origin.x + profileImageView.frame.size.width + profileImageView.frame.origin.x / 2
        label.frame.origin.y = 0
        label.frame.size.width = 100
        label.frame.size.height = 15
        label.font = UIFont(name: "Helvetica Neue", size: 11.0)
        label.textColor = UIColor.white
        
        self.addSubview(label)
    }
    
    private func setUserExperienceProgressBar(_ progressBar: UIProgressView) {
        progressBar.frame.origin.x = profileImageView.frame.origin.x + profileImageView.frame.size.width + profileImageView.frame.origin.x / 2
        progressBar.frame.origin.y = userNameLabel.frame.size.height
        progressBar.frame.size.width = 100
        progressBar.frame.size.height = 20
        progressBar.setProgress(0.5, animated: false)
        progressBar.progressTintColor = UIColor.white
        //progressBar.trackTintColor = UIColor.white
        self.addSubview(progressBar)
    }
    
    private func setScoreLabel(_ label: UILabel) {
        label.text = "999999999"
        label.frame.origin.x = profileImageView.frame.origin.x + profileImageView.frame.size.width + profileImageView.frame.origin.x / 2
        label.frame.origin.y = userNameLabel.frame.size.height + userExperienceProgressBar.frame.size.height + 2
        label.frame.size.width = 100
        label.frame.size.height = 10
        label.font = UIFont(name: "Helvetica Neue", size: 9.0)
        label.textColor = UIColor.white
        
        self.addSubview(label)
    }
    
    private func setLevelLabel(_ label: UILabel) {
        label.text = "Level 99"
        label.frame.origin.x = profileImageView.frame.origin.x + profileImageView.frame.size.width + profileImageView.frame.origin.x / 2
        label.frame.origin.y = scoreLabel.frame.origin.y + scoreLabel.frame.size.height
        label.frame.size.width = 100
        label.frame.size.height = 10
        label.font = UIFont(name: "Helvetica Neue", size: 9.0)
        label.textColor = UIColor.white
        
        self.addSubview(label)
    }
    
    private func setBottomLineView(_ view: UIView) {
        view.frame.size.width = self.frame.size.width / 1.25
        view.frame.size.height = 1
        view.frame.origin.x = ((self.frame.size.width / 2) - (view.frame.size.width / 2))
        view.frame.origin.y = self.frame.size.height - 1
        
        view.backgroundColor = UIColor.white
        
        self.addSubview(view)
    }

}
