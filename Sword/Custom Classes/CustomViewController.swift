//
//  CustomViewController.swift
//  Sword
//
//  Created by Muhammed Karakul on 24.06.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import UIKit
import AVFoundation

class CustomViewController: UIViewController, AVAudioPlayerDelegate {
    
    private var player: AVAudioPlayer?
    
    //private var blurEffectView = UIVisualEffectView()
    
    private var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Status bar color turns white
        //UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkInternetConnection()
    }
    
    public func checkInternetConnection() {
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        
        updateUserInterface()
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            // When internet connection is not available
            networkAlert()
            print("NETWORK CONNECTION TYPE: UNREACHABLE")
        case .wifi:
            // When internet connection is available via wifi
            print("NETWORK CONNECTION TYPE: WIFI")
        case .wwan:
            // When internet connection is available via cellular
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func playSound(withName name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            // Audio player delegate
            player.delegate = self

            player.play()

        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
//    internal func showBlurEffect( completion: ((Bool) -> Void)?) {
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.alpha = 0.0
//        self.view.addSubview(blurEffectView)
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.blurEffectView.alpha = 1.0
//        }, completion: completion)
//    }
//
//    internal func hideBlurEffect() {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.blurEffectView.alpha = 0.0
//        }) { (_) in
//            self.blurEffectView.removeFromSuperview()
//        }
//    }
    
    
//    internal func showAlert(withTitle title: String, andMessage message: String) {
//        alert(title: title, message: message, completion: {})
//        let cancelAction = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
//        alert.addAction(cancelAction)
//        self.present(alert, animated: true, completion: nil)
//    }

    internal func showAlert(withTitle title: String, andMessage message: String, andOKButtonHandler handler: ((UIAlertAction) -> Void)?) {
        alert(title: title, message: message, completion: {})
        let cancelAction = UIAlertAction(title: "Tamam", style: .cancel, handler: handler)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
