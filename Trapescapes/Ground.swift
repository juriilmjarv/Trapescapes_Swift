//
//  Ground.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ground.atlas")
    var groundTexture:SKTexture?
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1)
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        if groundTexture == nil {
            groundTexture = textureAtlas.textureNamed("g_mur4.png")
        }
        createChildren()
    }
    
    func createChildren() {
        if let texture = groundTexture {
            var tileCount: CGFloat = 0
            let textureSize = texture.size()
            let tileSize = CGSize(width: textureSize.width * 1.5, height: textureSize.height * 1.5)
            
            while tileCount * tileSize.height < self.size.height {
                let tileNode = SKSpriteNode(texture: texture)
                tileNode.size = tileSize
                tileNode.position.y = tileCount * tileSize.height
                tileNode.anchorPoint = CGPoint(x: 0, y: 1)

                self.addChild(tileNode)
                tileCount = tileCount + 1
            }
            jumpWidth = tileSize.width * floor(tileCount / 3)
        }
    }
    
    func checkForReposition(playerProgress:CGFloat) {
        // The ground needs to jump forward
        // every time the player has moved this distance:
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerProgress >= groundJumpPosition {
            // The player has moved past the jump position!
            // Move the ground forward:
            self.position.y += jumpWidth
            // Add one to the jump count:
            jumpCount = jumpCount + 1
        }
    }
    
    func onTap() {
        
    }
    
    
}
