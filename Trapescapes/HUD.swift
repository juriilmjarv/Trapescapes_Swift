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
    var backgroundLayer = SKShapeNode()
    var hudBar = SKShapeNode()
    
    let gameOverScore = SKLabelNode(text: "000000")
    

    
    func createHudNodes(screenSize: CGSize){
        
        hudBar = SKShapeNode(rectOf: CGSize(width: (screenSize.width * 2) + 1, height: -99))
        hudBar.fillColor = SKColor.black
        hudBar.lineWidth = 0
        hudBar.alpha = 0.4
        self.addChild(hudBar)
        
        for index in 0..<3 {
            //heart Source: https://opengameart.org/content/heart-7
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("Heart.png"))
            newHeartNode.size = CGSize(width: 63, height: 33)
            let xPos = CGFloat(index * 40 + 620)
            let yPos = CGFloat(-screenSize.height + 1308)
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
        coinCountText.fontSize = 30
        coinCountText.position = CGPoint(x: 90, y: -screenSize.height + 1295)
        self.addChild(coinCountText)
        
        backgroundLayer = SKShapeNode(rectOf: CGSize(width: (screenSize.width * 2) + 1, height: (-screenSize.height * 2) - 1))
        backgroundLayer.fillColor = SKColor.black
        backgroundLayer.alpha = 0.6
        //self.addChild(backgroundLayer)
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
            gameOverScore.text = coinCountText.text
        }
    }
    
    func showButtons() {
        restartButton.alpha = 0
        menuButton.alpha = 0
        
        //gameOverScore.text = coinCountText.text
        gameOverScore.fontSize = 100
        gameOverScore.position = CGPoint(x: 375, y: -600)
        self.addChild(gameOverScore)
        
        self.addChild(backgroundLayer)
        self.addChild(restartButton)
        self.addChild(menuButton)
        let fade = SKAction.fadeAlpha(to: 1, duration: 0.4)
        restartButton.run(fade)
        menuButton.run(fade)
    }
}
