//
//  EnemyGhost.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 12/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyGhost: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var fadeAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 50, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        //Sprite Source: https://opengameart.org/content/halloween-animation-ghost
        self.texture = textureAtlas.textureNamed("ghost-frown.png")
        self.run(fadeAnimation)
        self.alpha = 0.8
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedOwl.rawValue
    }
    
    func createAnimations() {
        let fadeOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.3, duration: 2),
            SKAction.scale(to: 0.8, duration: 2)
            ]);
        // Create a fade in action group:
        // The ghost returns to full size and transparency.
        let fadeInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.8, duration: 2),
            SKAction.scale(to: 1, duration: 2)
            ]);
        // Package the groups into a sequence, then a
        // repeatActionForever action:
        let fadeSequence = SKAction.sequence([fadeOutGroup,
                                              fadeInGroup])
        fadeAnimation = SKAction.repeatForever(fadeSequence)
    }

}
