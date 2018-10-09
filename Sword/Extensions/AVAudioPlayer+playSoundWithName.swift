//
//  AVAudioPlayer+playSoundWithName.swift
//  Sword
//
//  Created by Muhammed Karakul on 4.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    public static func playSound(withName name: String) -> AVAudioPlayer {
        
        var player = AVAudioPlayer()
        
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                player.play()
                
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        return player
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
