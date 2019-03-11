//
//  EnemyOne.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 11/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyOne: SKSpriteNode, GameSprite {
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "enemies.atlas")
    var mill = SKSpriteNode(imageNamed: "rotatingMill3.png")

    var spinAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 800 , height: 800)) {
        parentNode.addChild(mill)
        mill.size = size
        mill.position = position
        //Action for rotating mill
        let rotate = SKAction.rotate(byAngle: .pi / 3, duration: TimeInterval(speed))
        spinAnimation = SKAction.repeatForever(rotate)
        mill.run(spinAnimation)
    }
    
    func onTap() {
        
    }
    

}
