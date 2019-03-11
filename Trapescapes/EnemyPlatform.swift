//
//  EnemyPlatform.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 11/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyPlatform: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var platform = SKSpriteNode(imageNamed: "movingPlatform.png")

    var movingAction = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 300, height: 150)) {
        parentNode.addChild(platform)
        platform.size = size
        platform.position = position
        createMoving()
        platform.run(movingAction)
        
    }
    
    func createMoving() {
        let pathLeft = SKAction.moveBy(x: -200, y: 0, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 0, duration: 2)
        let movement = SKAction.sequence([pathLeft,pathRight])
        movingAction = SKAction.repeatForever(movement)
    }
    
    func onTap() {
        
    }
    
    
}
