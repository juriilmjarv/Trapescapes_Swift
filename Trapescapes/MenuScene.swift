//
//  MenuScene.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 30/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation

import SpriteKit

import GameKit



class MenuScene: SKScene, GKGameCenterControllerDelegate {
    
    
    
    let textures:SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    
    let startButton = SKSpriteNode()
    
    let muteBtn = SKSpriteNode()
    
    let unMuteBtn = SKSpriteNode()
    
    let instructionButton = SKSpriteNode()
    
    
    
    var userAuthenticated = false
    
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        self.backgroundColor = SKColor.black
        
        
        
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        
        logoText.text = "Trapescapes"
        
        logoText.position = CGPoint(x: self.size.width / 2, y: (-self.size.height / 2) + 500)
        
        logoText.fontSize = 100
        
        self.addChild(logoText)
        
        
        
        // button asset source: https://opengameart.org/content/ui-button
        
        startButton.texture = textures.textureNamed("buttonStock1.png")
        
        startButton.size = CGSize(width: 375, height: 220)
        
        startButton.name = "StartBtn"
        
        startButton.position = CGPoint(x: self.size.width / 2, y: -self.size.height / 2)
        
        self.addChild(startButton)
        
        let pulseUp = SKAction.scale(to: 1.1, duration: 1.0)
        
        let pulseDown = SKAction.scale(to: 1.0, duration: 1.0)
        
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        
        let repeatPulse = SKAction.repeatForever(pulse)
        
        startButton.run(repeatPulse)
        
        
        
        instructionButton.texture = textures.textureNamed("buttonStock1.png")
        
        instructionButton.size = CGSize(width: 375, height: 220)
        
        instructionButton.name = "instructionBtn"
        
        instructionButton.position = CGPoint(x: self.size.width / 2, y:(-self.size.height / 2) - 175)
        
        self.addChild(instructionButton)
        
        let instructionText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        
        instructionText.text = "INSTRUCTIONS"
        
        instructionText.verticalAlignmentMode = .center
        
        instructionText.position = CGPoint(x: 0, y: 3)
        
        instructionText.fontSize = 40
        
        instructionText.zPosition = 1
        
        instructionText.name = "instructionBtn"
        
        instructionButton.addChild(instructionText)
        
        
        
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
                
            } else if nodeTouched.name == "LeaderBoardBtn" {
                
                showLeaderboard()
                
            } else if nodeTouched.name == "instructionBtn" {
                
                self.removeAllChildren()
                
                self.removeAllActions()
                
                self.scene?.removeFromParent()
                
                let instructionSceneTemp = InstructionScene()
                
                instructionSceneTemp.scene?.anchorPoint = CGPoint(x: 0, y: 1)
                
                instructionSceneTemp.scene?.size = CGSize(width: 750, height: 1334)
                
                view?.presentScene(instructionSceneTemp, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
                
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
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if GKLocalPlayer.local.isAuthenticated && userAuthenticated == false {
            
            createLeaderboardButton()
            
            userAuthenticated = true
            
        }
        
    }
    
    
    
    func createLeaderboardButton(){
        
        let leaderboardText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        
        leaderboardText.text = "Leaderboard"
        
        leaderboardText.name = "LeaderBoardBtn"
        
        leaderboardText.position = CGPoint(x: self.size.width / 2, y: -self.size.height + 325)
        
        leaderboardText.fontSize = 35
        
        self.addChild(leaderboardText)
        
    }
    
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func showLeaderboard(){
        
        let gameCenter = GKGameCenterViewController()
        
        gameCenter.gameCenterDelegate = self
        
        gameCenter.viewState = .leaderboards
        
        gameCenter.leaderboardIdentifier = "trapescapes_Score"
        
        if let gameViewController = self.view?.window?.rootViewController {
            
            gameViewController.show(gameCenter, sender: self)
            
            gameViewController.navigationController?.pushViewController(gameCenter, animated: true)
            
        }
        
    }
    
    
    
    
    
}

