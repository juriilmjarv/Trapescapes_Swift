//
//  EnemyEagle.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 10/04/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyEagle:  SKSpriteNode, GameSprite{
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var movingAction = SKAction()
    
    var moveLeft:CGFloat = -200;
    var moveRight:CGFloat = 200;
    var moveUp:CGFloat = 0;
    var moveDown:CGFloat = 0;

    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 65, height: 60)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        let movingFrames:[SKTexture] = [textureAtlas.textureNamed("1.png"), textureAtlas.textureNamed("2.png"), textureAtlas.textureNamed("3.png"), textureAtlas.textureNamed("4.png")]
        let moveAction = SKAction.animate(with: movingFrames, timePerFrame: 0.14)
        let eagleAction = SKAction.repeatForever(moveAction)
        self.run(eagleAction)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.eagleCategory.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.bullet.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedOwl.rawValue
    
        self.run(movingAction)
        
        
    }
    
    func createAnimations() {
        let pathLeft = SKAction.moveBy(x: moveLeft, y: moveUp, duration: 2)
        let pathRight = SKAction.moveBy(x: moveRight, y: moveDown, duration: 2)
        let flipNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipPositive = SKAction.scaleX(to: 1, duration: 0)
        let movement = SKAction.sequence([pathRight,flipNegative,pathLeft, flipPositive])
        movingAction = SKAction.repeatForever(movement)
    }
    
    func wasShot(){
        self.physicsBody?.categoryBitMask = 0
        let shotAnimation = SKAction.group([SKAction.fadeAlpha(to: 0, duration: 0), SKAction.scale(to: 2.0, duration: 0)])
        let resetEagle = SKAction.run {
            self.position.y = -5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.eagleCategory.rawValue
        }
        
        let shotSequence = SKAction.sequence([shotAnimation,resetEagle])
        self.run(shotSequence)
    }
    
    func clone() -> EnemyEagle {
        return EnemyEagle()
    }

}
