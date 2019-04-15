//
//  MusicManager.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 15/04/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import AVFoundation

class MusicManager {
    
    //init Singleton
    static let shared = MusicManager()
    var music = AVAudioPlayer()
    var isPlaying = true
    
    //privat init to avoid multiple instances
    private init(){}
    
    //Prepare music file
    func setup() {
        let musicUrl = Bundle.main.url(forResource: "backgroundMusic.mp3", withExtension: nil)
        if let url = musicUrl {
            do {
                music = try AVAudioPlayer(contentsOf: url)
                music.numberOfLoops = -1
                music.prepareToPlay()
            } catch {
                print("Couldn't load music file")
            }
        }
    }
    
    //play music
    func play(){
        music.play()
        isPlaying = true
    }
    
    //stop music
    func stop(){
        music.stop()
        music.currentTime = 0
        music.prepareToPlay()
    }
    
    //pause music
    func pause(){
        music.pause()
        isPlaying = false
    }
    
    func checkIfPlaying() -> Bool{
        return isPlaying
    }
}
