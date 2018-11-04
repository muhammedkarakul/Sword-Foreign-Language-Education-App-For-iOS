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
    
    
    internal var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    internal var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
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
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    private func updateUserInterface() {
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
    
    func networkAlert() {
        let alert = UIAlertController(title: "Bağlantı Sorunu Oluştu", message: "İnternet bağlantınızda bir sorun olduğunu farkettik lütfen bağlantı durumunuzu kontrol ediniz.", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        let settingsAction = UIAlertAction(title: "Ayarlara Git", style: UIAlertAction.Style.default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
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
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
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
    
    internal func textToSpeech(withQuestion question: Question) {
        var language = ""
        
        switch question.getLanguage() {
        case .foreign: language = "en-UK"
        case .mother: language = "tr-TR"
        }
        
        let utterance = AVSpeechUtterance(string: question.getText())
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
