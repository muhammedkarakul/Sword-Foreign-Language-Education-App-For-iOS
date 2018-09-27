//
//  ProfileViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth
import Charts
import SwiftyPlistManager

class ProfileViewController: CustomMainViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var pickProfilePicturePopUpView: UIView!
    @IBOutlet var profilePicturesCollectionView: UICollectionView!
    @IBOutlet var chartView: PieChartView!
    
    private let userDefaults = UserDefaults.standard
    
    private var selectedIndexPathRow: Int?
    
    private var profilePictures = [String]()
    
    private var user = User()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Pop up view with rounded corners.
        pickProfilePicturePopUpView.layer.cornerRadius = 10
        
        // Profile picture collection view delegate and datasource
        profilePicturesCollectionView.delegate = self
        profilePicturesCollectionView.dataSource = self
        
        // Get default profile pictures form plist file
        getProfilePicturesFromPlistFile()
        
        // Setup view
        userImageView.image = UIImage(named: userDefaults.string(forKey: "ProfilePicture") ?? "defaultProfilePhoto-1")
        
        // Get current user data from Realm
        user = Utilities.getCurrentUserFromRealm()
        
        // Setup pie chart
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func cancelProfilePictureSelection(_ sender: UIButton) {
        pickProfilePicturePopUpView.removeFromSuperview()
        hideBlurView()
    }
    
    @IBAction func okProfilePictureSelection(_ sender: UIButton) {
        
        if let selectedProfilePicture = userDefaults.string(forKey: "ProfilePicture") {
            
            user.setProfilePhotoURL(profilePhotoURL: selectedProfilePicture)
            
            let realmUser = RealmUser()
            
            realmUser.getDataFromUser(user: user)
            
            realmUser.writeToRealm()
            
            userImageView.image = UIImage(named: selectedProfilePicture)
            
            headerView.update()
        }
        
        pickProfilePicturePopUpView.removeFromSuperview()
        
        hideBlurView()
    }
    
    @IBAction func pickProfilePicture(_ sender: UIButton) {
        
        showBlurView { (_) in
            self.view.addSubview(self.pickProfilePicturePopUpView)
            
            self.pickProfilePicturePopUpView.center = self.view.center
        }
        
        
    }
    
    @IBAction func logOutButtonTouchUpInside(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Uyarı", message: "Çıkış yapmak istediğinize emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        let yesAlertAction = UIAlertAction(title: "Evet", style: UIAlertAction.Style.cancel) { _ in
            guard (try? Auth.auth().signOut()) != nil else { return }
            self.performSegue(withIdentifier: "LoginViewController", sender: nil)
        }
        
        let noAlertAction = UIAlertAction(title: "Hayır", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(yesAlertAction)
        
        alert.addAction(noAlertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func getProfilePicturesFromPlistFile() {
        SwiftyPlistManager.shared.getValue(for: "DefaultProfilePhotos", fromPlistWithName: "DefaultProfilePictures") { (data, error) in
            if let err = error {
                print("Error: \(err)")
            } else {
                if let defaultProfilePictures = data as? [String] {
                    self.profilePictures = defaultProfilePictures
                }
            }
        }
    }
    
    
    // MARK: - ProfilePicturesCollectionView Datasource And Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilePictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProfilePictureCollectionViewCell
        
        cell.imageView.image = UIImage(named: profilePictures[indexPath.row])
        
        
        if selectedIndexPathRow != nil && indexPath.row == selectedIndexPathRow {
            cell.layer.backgroundColor = UIColor.customColors.swordBlue.cgColor
        } else {
            cell.layer.backgroundColor = UIColor.clear.cgColor;
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.backgroundColor = UIColor.customColors.swordBlue

        userDefaults.set(profilePictures[indexPath.row], forKey: "ProfilePicture")
        
        selectedIndexPathRow = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.backgroundColor = UIColor.clear
        
        selectedIndexPathRow = nil
    }

}

class ProfilePictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
}
