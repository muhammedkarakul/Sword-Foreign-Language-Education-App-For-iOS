//
//  ProfileViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 9.05.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: CustomMainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
