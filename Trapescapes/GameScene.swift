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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let world = SKNode()
    let ground = Ground()
    let player = Player()
    let hud = HUD()
    
    var currentMaxY:Int = 0
    var didFail = false
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(1000)
    
    let initialPlayerPosition = CGPoint(x: 0, y: -200)
    var playerProgress = CGFloat()
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    
    var coinsCollected = 0
    
    override func didMove(to view: SKView) {
        
        self.addChild(world)
        
        //Spawn the player
        player.spawn(parentNode: world, position: initialPlayerPosition)
        
        //spawn the ground
        let groundPosition = CGPoint(x: 0, y: -self.size.height)
        let groundSize = CGSize(width: 0 , height: self.size.height * 3)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        ground.zPosition = -1
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        //Accelerometer
        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
            (data:CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
                //make y acceleration very sensitive and work in opposite way which makes it easier to use.
                //self.yAcceleration = CGFloat(acceleration.y) * 2 + self.yAcceleration * 0.25
            }
        }
        
        //add encounters
        encounterManager.addEncountersToWorld(world: self.world)
        
        self.physicsWorld.contactDelegate = self
        
        hud.createHudNodes(screenSize: self.size)
        self.addChild(hud)
        hud.zPosition = 50
        
    }
    

    func touchDown(atPoint pos : CGPoint) {
        player.startFlapping()
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let location = t.location(in: self)
            let nodeTouched = atPoint(location)
            
            if(location.x > self.frame.size.width/2){
                player.startFlapping()
            }
            
            if(location.x < self.frame.size.width/2){
                fireBullet()
            }
            
            if nodeTouched.name == "restartGame"{
                self.removeAllChildren()
                self.removeAllActions()
                self.scene?.removeFromParent()
                let gameSceneTemp = GameScene(size: self.size)
                gameSceneTemp.anchorPoint = CGPoint(x: 0, y: 1)
                self.view?.presentScene(gameSceneTemp, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            } else if nodeTouched.name == "returnToMenu" {
                let gameSceneTemp = MenuScene()
                gameSceneTemp.scene?.anchorPoint = CGPoint(x: 0, y: 1)
                gameSceneTemp.scene?.size = CGSize(width: 750, height: 1334)
                view?.presentScene(gameSceneTemp, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchMoved(toPoint: t.location(in: self))
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            //player.stopFlapping()
            
        }
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            //player.stopFlapping()
        }
        player.stopFlapping()
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        player.update();
        
        //if Int(player.position.y) > currentMaxY {
        //    currentMaxY = Int(player.position.y)
       // }
    }
    
    
    override func didSimulatePhysics() {
        
        player.position.x += xAcceleration * 50
        //player.position.y += yAcceleration * 50
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20 , y: player.position.y)
        } else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
        //Dont let the player go out of camera from the bottom
        if player.position.y < -640 {
            player.position = CGPoint(x: player.position.x , y: self.size.height-self.size.height - 640)
        }
        
        
        if Int(player.position.y) > currentMaxY {
            currentMaxY = Int(player.position.y)
        }
        //TODO
        //If player falls then end game
        if Int(player.position.y) < currentMaxY - 1000 && !didFail {
            didFail = true
            print("GAME OVER!!!")
            player.health = 0
            hud.updateHealth(newHealth: player.health)
            player.takeDamage()
            gameOver()
        }
        
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody:SKPhysicsBody
        let beeMask = PhysicsCategory.bee.rawValue | PhysicsCategory.damagedBee.rawValue
        if(contact.bodyA.categoryBitMask & beeMask > 0){
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            player.takeDamage()
            hud.updateHealth(newHealth: player.health)
            print("Collision with enemy!!!!")
        case PhysicsCategory.coin.rawValue:
            print("Coin collison")
            if let coin = otherBody.node as? Coin {
                coin.collectCoin()
                self.coinsCollected += coin.val
                hud.coinCounter(newCoinCount: self.coinsCollected)
                print(self.coinsCollected)
            }
        default:
            print("contact with something other than enemy")
        }
    }
    
    func gameOver() {
        hud.showButtons()
    }
    
}

enum PhysicsCategory:UInt32 {
    case bee = 1
    case damagedBee = 2
    case enemy = 4
    case coin = 8
}
