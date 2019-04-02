//
//  HUD.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 30/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "hud.atlas")
    var heartNodes:[SKSpriteNode] = []
    let coinCountText = SKLabelNode(text: "000000")
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()

    
    func createHudNodes(screenSize: CGSize){
        
        for index in 0..<3 {
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("Heart.png"))
            newHeartNode.size = CGSize(width: 100, height: 45)
            let xPos = CGFloat(index * 60 + 33)
            let yPos = CGFloat(-screenSize.height + 1250)
            newHeartNode.position = CGPoint(x: xPos, y: yPos)
            heartNodes.append(newHeartNode)
            self.addChild(newHeartNode)
        }
        
        restartButton.texture = textureAtlas.textureNamed("play.png")
        menuButton.texture = textureAtlas.textureNamed("menu.png")
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        let centerOfHud = CGPoint(x: screenSize.width / 2 , y: -screenSize.height + 600)
        restartButton.position = centerOfHud
        menuButton.position = CGPoint(x: centerOfHud.x - 140 , y: centerOfHud.y)
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
        
        coinCountText.fontName = "Futura-Medium"
        coinCountText.fontSize = 40
        coinCountText.position = CGPoint(x: 75, y: -screenSize.height + 1300)
        self.addChild(coinCountText)
    }
    
    func updateHealth(newHealth: Int){
        let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.3)
        for index in 0..<heartNodes.count {
            if index < newHealth {
                heartNodes[index].alpha = 1
            } else {
                heartNodes[index].run(fadeAction)
            }
        }
    }
    
    func coinCounter(newCoinCount:Int){
        let formatter = NumberFormatter()
        let number = NSNumber(value: newCoinCount)
        formatter.minimumIntegerDigits = 6
        if let coinStr = formatter.string(from: number){
            coinCountText.text = coinStr
        }
    }
    
    func showButtons() {
        restartButton.alpha = 0
        menuButton.alpha = 0
        
        self.addChild(restartButton)
        self.addChild(menuButton)
        let fade = SKAction.fadeAlpha(to: 1, duration: 0.4)
        restartButton.run(fade)
        menuButton.run(fade)
    }
}
