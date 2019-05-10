//
//  InstructionScene.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 10/05/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit



class InstructionScene: SKScene {
    
    
    
    var background = SKSpriteNode(imageNamed: "instructions")
    
    let backButton = SKSpriteNode()
    
    
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        
        background.zPosition = 1
        
        background.position = CGPoint(x: self.size.width / 2 , y: -self.size.height / 2)
        
        background.size = CGSize(width: 577, height: 1026)
        
        addChild(background)
        
        print(background.size)
        
        
        
        let backBtn = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        
        backBtn.text = "BACK"
        
        backBtn.verticalAlignmentMode = .center
        
        backBtn.position = CGPoint(x: (self.size.width / 2) - 280, y: (-self.size.height / 2) + 625)
        
        backBtn.fontSize = 50
        
        backBtn.zPosition = 1
        
        backBtn.name = "backBtn"
        
        self.addChild(backBtn)
        
        let pulseUp = SKAction.scale(to: 1.1, duration: 1.0)
        
        let pulseDown = SKAction.scale(to: 1.0, duration: 1.0)
        
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        
        let repeatPulse = SKAction.repeatForever(pulse)
        
        backBtn.run(repeatPulse)
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            let location = t.location(in: self)
            
            let nodeTouched = atPoint(location)
            
            
            
            if nodeTouched.name == "backBtn" {
                
                let gameSceneTemp = MenuScene()
                
                gameSceneTemp.scene?.anchorPoint = CGPoint(x: 0, y: 1)
                
                gameSceneTemp.scene?.size = CGSize(width: 750, height: 1334)
                
                view?.presentScene(gameSceneTemp, transition: SKTransition.moveIn(with: .left, duration: 0.5))
                
            }
            
        }
        
    }
    
}

