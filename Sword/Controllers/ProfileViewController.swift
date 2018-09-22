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

class ProfileViewController: CustomMainViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var pickProfilePicturePopUpView: UIView!
    @IBOutlet var profilePicturesCollectionView: UICollectionView!
    @IBOutlet var chartView: PieChartView!
    
    private let userDefaults = UserDefaults.standard
    
    private var selectedIndexPathRow: Int?
    
    private let profilePictures: [String] =
        [
        "defaultProfilePhoto-1",
        "defaultProfilePhoto-2",
        "defaultProfilePhoto-3",
        "defaultProfilePhoto-4",
        "defaultProfilePhoto-5",
        "defaultProfilePhoto-6",
        "defaultProfilePhoto-7",
        "defaultProfilePhoto-8",
        "defaultProfilePhoto-9",
        "defaultProfilePhoto-10",
        "defaultProfilePhoto-11",
        "defaultProfilePhoto-12",
        "defaultProfilePhoto-13",
        "defaultProfilePhoto-14",
        "defaultProfilePhoto-15",
        "defaultProfilePhoto-16",
        "defaultProfilePhoto-17",
        "defaultProfilePhoto-20",
        "defaultProfilePhoto-21",
        "defaultProfilePhoto-22",
        "defaultProfilePhoto-23",
        "defaultProfilePhoto-24",
        "defaultProfilePhoto-25",
        "defaultProfilePhoto-26",
        "defaultProfilePhoto-27",
        "defaultProfilePhoto-28",
        "defaultProfilePhoto-29",
        "defaultProfilePhoto-30",
        "defaultProfilePhoto-31",
        "defaultProfilePhoto-32",
        "defaultProfilePhoto-33",
        "defaultProfilePhoto-34",
        ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Pop up view with rounded corners.
        pickProfilePicturePopUpView.layer.cornerRadius = 10
        
        // Profile picture collection view delegate and datasource
        profilePicturesCollectionView.delegate = self
        profilePicturesCollectionView.dataSource = self
        
        // Setup view
        userImageView.image = UIImage(named: userDefaults.string(forKey: "ProfilePicture") ?? "defaultProfilePhoto-1")
        
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
        userImageView.image = UIImage(named: userDefaults.string(forKey: "ProfilePicture") ?? "defaultProfilePhoto-0")
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
