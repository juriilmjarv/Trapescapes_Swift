//
//  Player.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, GameSprite  {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "player.atlas")
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    var flapping = false
    let maxFlappingForce:CGFloat = 90000
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.run(soarAnimation, withKey: "soarAnimation")
        
        let bodyTexture = textureAtlas.textureNamed("bee.png")
        self.physicsBody = SKPhysicsBody(
            texture: bodyTexture,
            size: size)
        // Pierre will lose momentum quickly with a high linearDamping:
        self.physicsBody?.linearDamping = 0.1
        // Adult penguins weigh around 30kg:
        self.physicsBody?.mass = 10
        // Prevent Pierre from rotating:
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.bee.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.coin.rawValue
        
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
        
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("bee.png")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        soarAnimation = SKAction.group([SKAction.repeatForever(soarAction)])
    }
    
    func startFlapping(){
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    func stopFlapping(){
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    
    func update(){
        //self.physicsBody?.velocity.dy = 200
        if self.flapping {
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: maxFlappingForce))
        }
        if (self.physicsBody?.velocity.dy)! > CGFloat(800) {
           self.physicsBody?.velocity.dy = 800
        }
    }
    
    func onTap() {
        
    }
    
    
}
