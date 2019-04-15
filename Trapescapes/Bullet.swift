//
//  Bullet.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 15/04/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode {
    
    
    
    func fireBullet(positionX: CGFloat){
        let sound = SKAudioNode(fileNamed: "shooting.aiff")
        sound.autoplayLooped = false
        addChild(sound)
        let playAction = SKAction.play()
        sound.run(playAction)
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.position = CGPoint(x: positionX , y: -self.size.height + 275)
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        
        let animationDuration:TimeInterval = 0.9
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: positionX, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actionArray))
    }

}
