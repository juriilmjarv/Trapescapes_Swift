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

    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 65, height: 60)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        let movingFrames:[SKTexture] = [textureAtlas.textureNamed("1.png"), textureAtlas.textureNamed("2.png"), textureAtlas.textureNamed("3.png"), textureAtlas.textureNamed("4.png")]
        let moveAction = SKAction.animate(with: movingFrames, timePerFrame: 0.14)
        let eagleAction = SKAction.repeatForever(moveAction)
        self.run(eagleAction)
    
        self.run(movingAction)
    }
    
    func createAnimations() {
        //let movingFrames:[SKTexture] = [textureAtlas.textureNamed("1.png"), textureAtlas.textureNamed("2.png"), textureAtlas.textureNamed("3.png"), textureAtlas.textureNamed("4.png")]
        //let moveAction = SKAction.animate(with: movingFrames, timePerFrame: 0.14)
        let pathLeft = SKAction.moveBy(x: -200, y: 0, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 0, duration: 2)
        let flipNegative = SKAction.scaleX(to: -1, duration: 0)
        let flipPositive = SKAction.scaleX(to: 1, duration: 0)
        let movement = SKAction.sequence([pathRight,flipNegative,pathLeft, flipPositive])
        movingAction = SKAction.repeatForever(movement)
    }
    
    
}
