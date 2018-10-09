//
//  UIViewController+FirebaseStorage.swift
//  FirebaseMediaStorageExamp
//
//  Created by Muhammed Karakul on 2.10.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseStorage
import ProgressHUD

extension UIViewController {
    
    var imageReferance: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    public func uploadImage(withImageName imageName: String?) {
        
        if let name = imageName {
            
            guard let image = UIImage(named: name) else { return }
            guard let imageData = image.jpegData(compressionQuality: 1) else { return }
            
            let uploadImageRef = imageReferance.child(name)
            
            showBlurView(withBlurEffectStyle: .dark) { (_) in}
            startActivityIndicator()
            
            let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
                
                self.stopActivityIndicator()
                self.hideBlurView()
                
                if let err = error {
                    ProgressHUD.showError("Upload failed! \n \(err.localizedDescription)")
                } else {
                    ProgressHUD.showSuccess("Upload successfully.")
                    if let meta = metadata {
                        print("METADATA: \(meta)")
                    }
                    
                }
                
            }
            
            //            uploadTask.observe(.progress) { (snapshot) in
            //                print(snapshot)
            //            }
            
            uploadTask.resume()
        }
    }
    
    public func downloadImage(withName imageName: String?) -> UIImage {
        
        var downloadedImage = UIImage()
        
        if let name = imageName {
            
            let downloadImageRef = imageReferance.child(name)
            
            showBlurView(withBlurEffectStyle: .dark) { (_) in}
            startActivityIndicator()
            
            let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                
                self.stopActivityIndicator()
                self.hideBlurView()
                
                if let err = error {
                    ProgressHUD.showError("Upload failed! \n \(err.localizedDescription)")
                } else {
                    ProgressHUD.showSuccess("Download successfully.")
                    
                    if let data = data {
                        if let image = UIImage(data: data) {
                            downloadedImage = image
                        }
                    }
                }
                
            }
            
            //        downloadTask.observe(.progress) { (snapshot) in
            //            print(snapshot)
            //        }
            
            downloadTask.resume()
        }
        
        return downloadedImage
    }
}

