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
                self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25
            }
        }

        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
        
    }

}
