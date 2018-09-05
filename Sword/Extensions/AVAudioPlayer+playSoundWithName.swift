//
//  AVAudioPlayer+playSoundWithName.swift
//  Sword
//
//  Created by Muhammed Karakul on 4.09.2018.
//  Copyright © 2018 Muhammed Karakul. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAudioPlayer {
    public static func playSound(withName name: String) -> AVAudioPlayer {
        
        var player = AVAudioPlayer()
        
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
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
