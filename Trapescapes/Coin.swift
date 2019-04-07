//
//  Coin.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 02/04/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class Coin:SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var val = 100
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 26, height: 26)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("gold.png")
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    func collectCoin(){
        self.physicsBody?.categoryBitMask = 0
        let collectAnimation = SKAction.group([SKAction.fadeAlpha(to: 0, duration: 0.2), SKAction.scale(to: 1.5, duration: 0.2), SKAction.moveBy(x: 0, y: 25, duration: 0.2)])
        let resetCoin = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        
        let collectSequence = SKAction.sequence([collectAnimation,resetCoin])
        self.run(collectSequence)
    }

    
}
