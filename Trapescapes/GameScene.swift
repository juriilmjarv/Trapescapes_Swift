//
//  GameScene.swift
//  Trapescapes
//
//  Created by Jüri Ilmjärv on 08/03/2019.
//  Copyright © 2019 Juri Ilmjarv. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    let world = SKNode()
    let ground = Ground()
    let player = Player()
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(500)
    
    let initialPlayerPosition = CGPoint(x: 0, y: -200)
    var playerProgress = CGFloat()
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var yAcceleration:CGFloat = 0
    
    override func didMove(to view: SKView) {
        
        self.addChild(world)
        
        //Spawn the player
        player.spawn(parentNode: world, position: initialPlayerPosition)
        player.zPosition = 2

        //spawn the ground
        let groundPosition = CGPoint(x: 0, y: -self.size.height)
        let groundSize = CGSize(width: 0 , height: self.size.height * 3)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        
        //Accelerometer
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
            (data:CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
                //make y acceleration very sensitive and work in opposite way which makes it easier to use.
                self.yAcceleration = CGFloat(acceleration.y) * 2 + self.yAcceleration * 0.25
            }
        }
        
        //add encounters
        encounterManager.addEncountersToWorld(world: self.world)
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
            fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        playerProgress = player.position.y + initialPlayerPosition.y

    }
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        player.position.y += yAcceleration * 50
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20 , y: player.position.y)
        } else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
        //Dont let the player go out of camera from the bottom
        if player.position.y < -640 {
            player.position = CGPoint(x: player.position.x , y: self.size.height-self.size.height - 640)
        }
        
        //TODO
        // Figure out player position and scroll the world based on that.
        let worldYPos = -(player.position.y * world.yScale + (self.size.height / 1.2))
        world.position = CGPoint(x: 0, y: worldYPos)

        
        playerProgress = player.position.y - initialPlayerPosition.y
        ground.checkForReposition(playerProgress: playerProgress)
        
        //Check if we need to place a new encounter
        if player.position.y > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentYPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 2000
        }
        
    }
    
    func fireBullet() {
        self.run(SKAction.playSoundFileNamed("shooting.mp3", waitForCompletion: false))
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.position = CGPoint(x: player.position.x , y: -self.size.height + 275)
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        
        let animationDuration:TimeInterval = 0.9
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actionArray))
    }
    
    

}
