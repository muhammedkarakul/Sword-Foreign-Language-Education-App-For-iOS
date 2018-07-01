//
//  MainViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 22.04.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit

class MainViewController: CustomViewController {

    // MARK: Preferences -
    
    @IBOutlet var loginWithUserNameButton: UIButtonWithRoundedCorners!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Status bar color turns white
        //UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //loginWithUserNameButton.titleLabel?.textColor = UIColor.white
        
        //NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        //updateUserInterface()
        
    }
    /*
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            //view.backgroundColor = .red
            networkAlert()
            print("NETWORK CONNECTION TYPE: UNREACHABLE")
        case .wifi:
            //view.backgroundColor = .green
            print("NETWORK CONNECTION TYPE: WIFI")
        case .wwan:
            //view.backgroundColor = .yellow
            print("NETWORK CONNECTION TYPE: CELLULAR")
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    func networkAlert() {
        let alert = UIAlertController(title: "Bağlantı Sorunu Oluştu", message: "İnternet bağlantınızda bir sorun olduğunu farkettik lütfen bağlantı durumunuzu kontrol ediniz.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        let settingsAction = UIAlertAction(title: "Ayarlara Git", style: UIAlertActionStyle.default) { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    @IBAction func loginWithUserName(_ sender: UIButtonWithRoundedCorners) {
        // Status bar color turns default(black)
        UIApplication.shared.statusBarStyle = .default
        
        // Go to login with user name view
        performSegue(withIdentifier: "segueLoginWithUserName", sender: self)
    }
    
    @IBAction func loginWithFaceBook(_ sender: UIButtonWithRoundedCorners) {
        // Status bar color turns default(black)
        UIApplication.shared.statusBarStyle = .default
        
        // Go to login with face book view
        performSegue(withIdentifier: "segueLoginWithFaceBook", sender: self)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        // Status bar color turns default(black)
        UIApplication.shared.statusBarStyle = .default
        
        // Go to sign up view
        performSegue(withIdentifier: "segueSignUp", sender: self)
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
