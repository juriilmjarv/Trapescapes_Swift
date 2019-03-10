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
    var moveAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        self.run(moveAnimation)
        
    }
    
    func createAnimations() {
        let moveFrames:[SKTexture] = [textureAtlas.textureNamed("bee.png"), textureAtlas.textureNamed("bee_fly.png")]
        let flyAction = SKAction.animate(with: moveFrames, timePerFrame: 0.14)
        moveAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        
    }
    
    
}
