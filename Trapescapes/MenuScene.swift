//
//  MenuScene.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 30/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    let textures:SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    let startButton = SKSpriteNode()
    let muteBtn = SKSpriteNode()
    let unMuteBtn = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Trapescapes"
        logoText.position = CGPoint(x: self.size.width / 2, y: (-self.size.height / 2) + 200)
        logoText.fontSize = 50
        self.addChild(logoText)
        
        startButton.texture = textures.textureNamed("button.png")
        startButton.size = CGSize(width: 350, height: 100)
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: self.size.width / 2, y: -self.size.height / 2)
        self.addChild(startButton)
        
        //Texture Source: https://opengameart.org/content/play-pause-mute-and-unmute-buttons
        muteBtn.texture = textures.textureNamed("unmute.png")
        muteBtn.size = CGSize(width: 74, height: 74)
        muteBtn.name = "muteBtn"
        muteBtn.position = CGPoint(x: self.size.width / 2, y: -self.size.height + 100)
        
        //Texture Source: https://opengameart.org/content/play-pause-mute-and-unmute-buttons
        unMuteBtn.texture = textures.textureNamed("mute.png")
        unMuteBtn.size = CGSize(width: 74, height: 74)
        unMuteBtn.name = "unMuteBtn"
        unMuteBtn.position = CGPoint(x: self.size.width / 2, y: -self.size.height + 100)
        
        //Check if should load mute or unMute button
        if MusicManager.shared.checkIfPlaying() == true {
            self.addChild(muteBtn)
        } else{
            self.addChild(unMuteBtn)
        }
        
        
        
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        startText.zPosition = 1
        startText.name = "StartBtn"
        startButton.addChild(startText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let nodeTouched = atPoint(location)            
            if nodeTouched.name == "StartBtn" {
                self.removeAllChildren()
                self.removeAllActions()
                self.scene?.removeFromParent()
                let gameSceneTemp = GameScene(size: self.size)
                gameSceneTemp.anchorPoint = CGPoint(x: 0, y: 1)
                self.view?.presentScene(gameSceneTemp, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
            
            if nodeTouched.name == "muteBtn" {
                muteBtn.removeFromParent()
                self.addChild(unMuteBtn)
                MusicManager.shared.pause()
            }
            
            if nodeTouched.name == "unMuteBtn" {
                unMuteBtn.removeFromParent()
                self.addChild(muteBtn)
                MusicManager.shared.play()
            }
        }
    }
}
