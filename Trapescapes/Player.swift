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
    var maxFlappingForce:CGFloat = 90000
    
    var health:Int = 3
    var damaged = false
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 75, height: 75)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.run(soarAnimation, withKey: "soarAnimation")
        
        let bodyTexture = textureAtlas.textureNamed("left-1.png")
        self.physicsBody = SKPhysicsBody(
            texture: bodyTexture,
            size: size)
        self.physicsBody?.linearDamping = 0.1
        self.physicsBody?.mass = 10
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.bee.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.coin.rawValue
        
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [textureAtlas.textureNamed("left-0.png"), textureAtlas.textureNamed("left-1.png"), textureAtlas.textureNamed("left-2.png"), textureAtlas.textureNamed("left-3.png"), textureAtlas.textureNamed("left-4.png"), textureAtlas.textureNamed("left-5.png")]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.02)
        flyAnimation = SKAction.repeatForever(flyAction)
        
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("left-1.png")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        soarAnimation = SKAction.group([SKAction.repeatForever(soarAction)])
        
        let startDie = SKAction.run{
            self.texture = self.textureAtlas.textureNamed("dead.png")
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.isDynamic = false
            self.isPaused = true

        }
        let endDie = SKAction.run {
            self.physicsBody?.affectedByGravity = false
        }
        self.dieAnimation = SKAction.sequence([
            startDie,
            // Scale the penguin bigger:
            SKAction.scale(to: 1.3, duration: 0.1),
            // Use the waitForDuration action to provide a short pause:
            SKAction.wait(forDuration: 0.1),
            // Rotate the penguin on to his back:
            SKAction.rotate(toAngle: 3, duration: 0.5),
            SKAction.wait(forDuration: 0.5),
            endDie
            ])
    }
    
    func startFlapping(){
        if self.health <= 0 {return}
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    func stopFlapping(){
        if self.health <= 0 {return}
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
    
    func die() {
        // Make sure the player is fully visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run the die animation:
        self.run(self.dieAnimation)
        // Prevent any further upward movement:
        self.flapping = false
        // Stop forward movement:
        self.maxFlappingForce = 0
        if let gameScene = self.parent?.parent as? GameScene {
            gameScene.gameOver()
        }
    }
    
    func freeFallDie() {
        // Make sure the player is fully visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run the die animation:
        self.run(self.dieAnimation)
        // Prevent any further upward movement:
        self.flapping = false
        // Stop forward movement:
        self.maxFlappingForce = 0
    }
    
    func takeDamage() {
        // If invulnerable or damaged, return:
        if self.damaged { return }
        //self.damaged = true
        // Remove one from our health pool
        self.health -= 1
        if self.health == 0 {
            // If we are out of health, run the die function:
            die()
        } else if self.health == -1 {
            freeFallDie()
        } else {
            // Run the take damage animation:
            self.run(self.damageAnimation)
        }
    }

}
