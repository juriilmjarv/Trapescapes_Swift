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
    
    let countdownLabel = SKLabelNode()
    var count = 3
    
    var currentMaxY:Int = 0
    var didFail = false
    
    let encounterManager = EncounterManager()
    var nextEncounterSpawnPosition = CGFloat(1000)
    
    let initialPlayerPosition = CGPoint(x: 375, y: -200)
    var playerProgress = CGFloat()
    
    //let motionManager = CMMotionManager()
    var motionManager: CMMotionManager!
    var xAcceleration:CGFloat = 0
    
    var score = 0
    
    private var activeTouches = [UITouch:String]()
    
    override func didMove(to view: SKView) {
        
        self.view?.isMultipleTouchEnabled = true
        
        
        self.addChild(world)
        
        //Spawn the player
        player.spawn(parentNode: world, position: initialPlayerPosition)
        //This is for not allowing for player movement until countdown is 0
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        
        
        //spawn the ground
        let groundPosition = CGPoint(x: 0, y: -self.size.height)
        let groundSize = CGSize(width: 0 , height: self.size.height * 3)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        ground.zPosition = -1
        
        //set gravity on y axis
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -12)
        
        //Accelerometer
        //motionManager.accelerometerUpdateInterval = 0.01
        //motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {
        //    (data:CMAccelerometerData?, error: Error?) in
        //    if let accelerometerData = data {
        //        let acceleration = accelerometerData.acceleration
        //        self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
        //    }
        //}
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        
        //add encounters
        encounterManager.addEncountersToWorld(world: self.world)
        
        self.physicsWorld.contactDelegate = self
        
        hud.createHudNodes(screenSize: self.size)
        self.addChild(hud)
        hud.zPosition = 50
        
        countdown(count: 3)
        
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
            
            let button = findButtonName(from: t)
            activeTouches[t] = button
            tapBegin(on: button)

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
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
            guard let button = activeTouches[t] else {fatalError("Touch just ended but not found into activeTouches")}
            activeTouches[t] = nil
            tapEnd(on: button)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
        player.stopFlapping()
    }

    private func tapBegin(on button: String) {
        if(button == "right") {
            player.startFlapping()
        } else if button == "left" {
            fireBullet()
        }
    }
    
    private func tapEnd(on button:String) {
        if(button == "right") {
            player.stopFlapping()
        }
    }
    
    private func findButtonName(from touch: UITouch) -> String {
        let location = touch.location(in: self)
        if location.x > self.frame.size.width/2 {
            return "right"
        } else {
            return "left"
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        player.update();
        if let data = motionManager.accelerometerData {
            let acceleration = data.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
        }
        player.position.x += xAcceleration * 50
    }
    
    override func didSimulatePhysics() {
        
        //if player exceeds left/right edge then place it on left/right to prevent disapearing
        //player.position.x += xAcceleration * 50
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20 , y: player.position.y)
        } else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
        }
        
        //Keep track of current max Y position
        if Int(player.position.y) > currentMaxY {
            
            score += 1
            currentMaxY = Int(player.position.y)
            hud.coinCounter(newCoinCount: self.score)
        }
        
        //If player falls 1000px then end game and set didFail to true to prevent goint into endless loop
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
    
   
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody:SKPhysicsBody
        let owlMask = PhysicsCategory.playerOwl.rawValue | PhysicsCategory.damagedOwl.rawValue
        if(contact.bodyA.categoryBitMask & owlMask > 0){
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case PhysicsCategory.enemy.rawValue:
            player.takeDamage()
            hud.updateHealth(newHealth: player.health)
            player.makePlayerImmortal()
            print("Collision with enemy!!!!")
            let emitter = SKEmitterNode(fileNamed: "Explosion1.sks")!
            emitter.position = CGPoint(x: player.position.x, y: -self.size.height + 250)
            let addEmitterAction = SKAction.run({self.addChild(emitter)})
            let emitterDuration = 0.5
            let wait = SKAction.wait(forDuration: TimeInterval(emitterDuration))
            let remove = SKAction.run({emitter.removeFromParent(); print("Emitter removed")})
            let sequence = SKAction.sequence([addEmitterAction, wait, remove])
            self.run(sequence)
        case PhysicsCategory.coin.rawValue:
            print("Coin collison")
            if let coin = otherBody.node as? Coin {
                coin.collectCoin()
                self.score += coin.val
                hud.coinCounter(newCoinCount: self.score)
            }
        default:
            print("contact with something other than enemy")
        }
        
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & PhysicsCategory.bullet.rawValue) != 0 && (secondBody.categoryBitMask & PhysicsCategory.eagleCategory.rawValue) != 0 {
            bulletDidCollideWithEnemy(bulletNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
            if let enemyEagle = secondBody.node as? EnemyEagle {
                enemyEagle.wasShot()
                self.score += 100
            }
        }
        
        if(firstBody.categoryBitMask & PhysicsCategory.playerOwl.rawValue) != 0 && (secondBody.categoryBitMask & PhysicsCategory.eagleCategory.rawValue) != 0 {
            player.takeDamage()
            hud.updateHealth(newHealth: player.health)
            player.makePlayerImmortal()
            let emitter = SKEmitterNode(fileNamed: "Explosion1.sks")!
            emitter.position = CGPoint(x: player.position.x, y: -self.size.height + 250)
            let addEmitterAction = SKAction.run({self.addChild(emitter)})
            let emitterDuration = 0.5
            let wait = SKAction.wait(forDuration: TimeInterval(emitterDuration))
            let remove = SKAction.run({emitter.removeFromParent(); print("Emitter removed")})
            let sequence = SKAction.sequence([addEmitterAction, wait, remove])
            self.run(sequence)
        }
    }
    
    func bulletDidCollideWithEnemy(bulletNode:SKSpriteNode, enemyNode:SKSpriteNode) {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion1")!
        explosion.position = bulletNode.position
        self.addChild(explosion)
        
        bulletNode.removeFromParent()
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
    }
    
    func gameOver() {
        hud.showButtons()
        motionManager.stopAccelerometerUpdates()
    }
    
    /*
     countdown before game start
     Source: https://stackoverflow.com/questions/35943307/ios-spritekit-countdown-before-game-starts
     */
    func countdown(count: Int) {
        countdownLabel.position = CGPoint(x: self.size.width / 2, y: -self.size.height / 2)
        countdownLabel.fontName = "GujaratiSangamMN-Bold"
        countdownLabel.fontColor = SKColor.white
        countdownLabel.fontSize = 150
        countdownLabel.zPosition = 100
        countdownLabel.text = "\(count)"
        
        self.addChild(countdownLabel)
        
        let pulseUp = SKAction.scale(to: 3.0, duration: 0.5)
        let pulseDown = SKAction.scale(to: 0.5, duration: 0.5)
        let pulse = SKAction.sequence([pulseUp, pulseDown])
        let repeatPulse = SKAction.repeatForever(pulse)
        self.countdownLabel.run(repeatPulse)
        
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countdownAction)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: 3),
                               SKAction.run(endCountdown)]))
        
    }
    
    func countdownAction() {
        count = count - 1
        countdownLabel.text = "\(count)"
    }
    
    func endCountdown() {
        countdownLabel.removeFromParent()
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.isDynamic = true
    }
    
    func fireBullet() {
        let sound = SKAudioNode(fileNamed: "shooting.aiff")
        sound.autoplayLooped = false
        addChild(sound)
        let playAction = SKAction.play()
        sound.run(playAction)
        //self.run(SKAction.playSoundFileNamed("shooting.mp3", waitForCompletion: false))
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.position = CGPoint(x: player.position.x , y: -self.size.height + 275)
        bullet.zPosition = 2
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width / 2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet.rawValue
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.eagleCategory.rawValue
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        self.addChild(bullet)
        
        let animationDuration:TimeInterval = 0.9
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: self.frame.size.height + 10), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        bullet.run(SKAction.sequence(actionArray))
    }
 
    
}

enum PhysicsCategory:UInt32 {
    case playerOwl = 1
    case damagedOwl = 2
    case enemy = 4
    case coin = 8
    case bullet = 16
    case eagleCategory = 32
}

