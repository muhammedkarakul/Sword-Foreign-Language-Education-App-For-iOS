//
//  ProfileViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: CustomMainViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var pickProfilePicturePopUpView: UIView!
    @IBOutlet var profilePicturesCollectionView: UICollectionView!
    let profilePictures: [String] = ["defaultProfilePhoto-0", "defaultProfilePhoto-1",  "defaultProfilePhoto-2", "defaultProfilePhoto-3", "defaultProfilePhoto-4", "defaultProfilePhoto-5", "defaultProfilePhoto-6", "defaultProfilePhoto-7", "defaultProfilePhoto-8", "defaultProfilePhoto-9", "defaultProfilePhoto-10", "defaultProfilePhoto-11", "defaultProfilePhoto-12", "defaultProfilePhoto-13", "defaultProfilePhoto-14", "defaultProfilePhoto-15", "defaultProfilePhoto-16", "defaultProfilePhoto-19", "defaultProfilePhoto-20", "defaultProfilePhoto-21", "defaultProfilePhoto-22", "defaultProfilePhoto-23", "defaultProfilePhoto-24", "defaultProfilePhoto-25", "defaultProfilePhoto-26", "defaultProfilePhoto-27", "defaultProfilePhoto-28", "defaultProfilePhoto-29", "defaultProfilePhoto-30", "defaultProfilePhoto-31", "defaultProfilePhoto-32", "defaultProfilePhoto-33", "defaultProfilePhoto-34", ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Pop up view with rounded corners.
        pickProfilePicturePopUpView.layer.cornerRadius = 10
        
        // Profile picture collection view delegate and datasource
        profilePicturesCollectionView.delegate = self
        profilePicturesCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancelProfilePictureSelection(_ sender: UIButton) {
        pickProfilePicturePopUpView.removeFromSuperview()
    }
    
    @IBAction func pickProfilePicture(_ sender: UIButton) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        self.view.addSubview(pickProfilePicturePopUpView)
        pickProfilePicturePopUpView.center = self.view.center
    }
    
    @IBAction func logOutButtonTouchUpInside(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Uyarı", message: "Çıkış yapmak istediğinize emin misiniz?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAlertAction = UIAlertAction(title: "Evet", style: UIAlertActionStyle.cancel) { _ in
            guard (try? Auth.auth().signOut()) != nil else { return }
            self.performSegue(withIdentifier: "LoginViewController", sender: nil)
        }
        
        let noAlertAction = UIAlertAction(title: "Hayır", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(yesAlertAction)
        
        alert.addAction(noAlertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - ProfilePicturesCollectionView Datasource And Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfilePictureCollectionViewCell
        
        cell.imageView.image = UIImage(named: profilePictures[indexPath.row])
        
        return cell
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

class ProfilePictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}
