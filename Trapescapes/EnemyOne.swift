//
//  EnemyOne.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 11/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

//Obstacle that looks like mill. Rotates. Uses prototype design pattern
class EnemyOne: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var mill = SKSpriteNode(imageNamed: "rotatingMill3.png")

    var spinAnimation = SKAction()
    var rotation:CGFloat = .pi
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 800 , height: 800)) {
        parentNode.addChild(mill)
        mill.size = size
        mill.position = position
        //Action for rotating mill
        let rotate = SKAction.rotate(byAngle: rotation / 3, duration: TimeInterval(speed))
        spinAnimation = SKAction.repeatForever(rotate)
        mill.run(spinAnimation)
        mill.physicsBody = SKPhysicsBody(texture: mill.texture!, size: mill.size)
        mill.physicsBody?.affectedByGravity = false
        mill.physicsBody?.isDynamic = false        
        mill.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue 
        mill.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedOwl.rawValue
    }
    
    func clone() -> EnemyOne {
        return EnemyOne()
    }
}
